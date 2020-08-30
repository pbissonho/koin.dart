/*
 * Copyright 2017-2018 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:core';
import 'package:equatable/equatable.dart';
import '../qualifier.dart';
import '../scope/scope_definition.dart';
import 'definition.dart';

class Callback<T> {
  final void Function(T value) _callBack;

  bool hasCallback() => _callBack != null;

  void runCallback(T value) {
    if (hasCallback()) {
      _callBack(value);
    }
  }

  Callback({Function(T value) callback}) : _callBack = callback;
}

enum Kind {
  single,
  factory,
}

class Options {
  final bool isCreatedAtStart;
  final bool override;

  const Options({this.isCreatedAtStart = false, this.override = false});
}

///
/// Koin bean definition
/// main structure to make definition in Koin
// @author - Arnaud GIULIANI
//
// Ported to Dart from Kotlin by:
// @author - Pedro Bissonho
//
class BeanDefinition<T> with EquatableMixin {
  final ScopeDefinition scopeDefinition;
  final Type primaryType;
  final Qualifier qualifier;
  final DefinitionBase<T> definition;
  final Kind kind;
  List<Type> secondaryTypes;
  final Options options;
  Callback<T> onDispose;

  BeanDefinition(
      {this.scopeDefinition,
      this.primaryType,
      this.qualifier,
      this.definition,
      this.kind,
      this.options = const Options(),
      Callback<T> onDispose,
      List<Type> secondaryTypes}) {
    if (secondaryTypes == null) {
      this.secondaryTypes = <Type>[];
    } else {
      this.secondaryTypes = secondaryTypes;
    }

    if (onDispose == null) {
      this.onDispose = Callback<T>();
    } else {
      this.onDispose = onDispose;
    }
  }

  BeanDefinition<T> copy({List<Type> secondaryTypes, Callback<T> onDispose}) {
    var newSecondaryTypes;
    var onDisposeCopy;

    if (secondaryTypes == null) {
      newSecondaryTypes = this.secondaryTypes;
    } else {
      newSecondaryTypes = secondaryTypes;
    }

    if (onDispose == null) {
      onDisposeCopy = this.onDispose;
    } else {
      onDisposeCopy = onDispose;
    }

    return BeanDefinition<T>(
        scopeDefinition: scopeDefinition,
        primaryType: primaryType,
        qualifier: qualifier,
        definition: definition,
        kind: kind,
        options: options,
        secondaryTypes: newSecondaryTypes,
        onDispose: onDisposeCopy);
  }

  @override
  String toString() {
    var defKind = kind.toString();
    var defType = "'${primaryType.toString()}'";

    var defName = qualifier != null ? 'qualifier:$qualifier' : '';
    var defScope =
        scopeDefinition.isRoot ? '' : 'scope:${scopeDefinition.qualifier}';

    var defOtherTypes;

    if (secondaryTypes.isNotEmpty) {
      var typesAsString =
          secondaryTypes.map((type) => type.toString()).join(',').toString();
      defOtherTypes = 'binds:$typesAsString';
    } else {
      defOtherTypes = '';
    }

    return '[$defKind:$defType$defName$defScope$defOtherTypes]';
  }

  @override
  List<Object> get props => [primaryType, qualifier, scopeDefinition];

  bool hasType(Type type) {
    return primaryType == type || secondaryTypes.contains(type);
  }

  bool isIt(Type type, Qualifier qualifier, ScopeDefinition scopeDefinition) {
    return hasType(type) &&
        qualifier == this.qualifier &&
        this.scopeDefinition == scopeDefinition;
  }

  bool canBind(Type primary, Type secondary) {
    return primaryType == primary && secondaryTypes.contains(secondary);
  }

  ///
  /// Definition Binding
  ///
  BeanDefinition bind<S>() {
    var newTypes = List<Type>.from([S]);
    newTypes.addAll(secondaryTypes);

    var copyT = copy(secondaryTypes: newTypes);
    scopeDefinition.remove(this);
    scopeDefinition.save(copyT);
    return copyT;
  }

  ///
  /// Definition Bindings
  ///
  BeanDefinition binds(List<Type> types) {
    types.addAll(secondaryTypes);

    var copyT = copy(secondaryTypes: types);
    scopeDefinition.remove(this);
    scopeDefinition.save(copyT);
    return copyT;
  }

  ///
  /// OnCloseCallback is called when definition is closed.
  BeanDefinition<T> onClose(void Function(T value) onDispose) {
    var scopeDefinitionCopy = copy(onDispose: Callback(callback: onDispose));
    scopeDefinition.remove(this);
    scopeDefinition.save(scopeDefinitionCopy);
    return scopeDefinitionCopy;
  }
}

///
/// Converte the 'type' and 'qualifier'
///
String indexKey(Type type, Qualifier qualifier) {
  if (qualifier?.value != null) {
    return '${type.toString()}::${qualifier.value}';
  } else {
    return type.toString();
  }
}
