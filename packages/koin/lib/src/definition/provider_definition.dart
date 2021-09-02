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
import '../qualifier.dart';
import '../scope/scope_definition.dart';
import 'definition.dart';

class Callback<T> {
  final void Function(T value) callback;
  final void Function() callbackForUninitializedValue;

  const Callback(
      {required this.callbackForUninitializedValue, required this.callback});
  void runCallback(T value) {
    callback(value);
  }

  void runCallbackUninitializedValue() {
    callbackForUninitializedValue();
  }
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
class ProviderDefinition<T> {
  final ScopeDefinition scopeDefinition;
  final Type primaryType;
  final Qualifier? qualifier;
  final ProviderCreateBase<T> definition;
  final Kind kind;
  final List<Type> secondaryTypes;
  final Options options;
  late final Callback<T> onDispose;

  ProviderDefinition(
      {required this.scopeDefinition,
      required this.primaryType,
      required this.qualifier,
      required this.definition,
      required this.kind,
      this.options = const Options(),
      Callback<T>? onDispose,
      this.secondaryTypes = const <Type>[]}) {
    if (onDispose == null) {
      this.onDispose = Callback<T>(
          callbackForUninitializedValue: () {}, callback: (value) {});
    } else {
      this.onDispose = onDispose;
    }
  }

  ProviderDefinition<T> copy(
      {List<Type>? secondaryTypes, Callback<T>? onDispose}) {
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

    return ProviderDefinition<T>(
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
    final defKind = kind.toString();
    final defType = "'${primaryType.toString()}'";

    final defName = qualifier != null ? 'qualifier:$qualifier' : '';
    final defScope =
        scopeDefinition.isRoot ? '' : 'scope:${scopeDefinition.qualifier}';

    late final defOtherTypes;

    if (secondaryTypes.isNotEmpty) {
      final typesAsString =
          secondaryTypes.map((type) => type.toString()).join(',').toString();
      defOtherTypes = 'binds:$typesAsString';
    } else {
      defOtherTypes = '';
    }

    return '[$defKind:$defType$defName$defScope$defOtherTypes]';
  }

  bool hasType(Type type) {
    return primaryType == type || secondaryTypes.contains(type);
  }

  bool isIt(Type type, Qualifier? qualifier, ScopeDefinition scopeDefinition) {
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
  ProviderDefinition bind<S>() {
    final newTypes = List<Type>.from([S]);
    newTypes.addAll(secondaryTypes);

    final copyT = copy(secondaryTypes: newTypes);
    scopeDefinition.remove(this);
    scopeDefinition.save(copyT);
    return copyT;
  }

  ///
  /// Definition Bindings
  ///
  ProviderDefinition binds(List<Type> types) {
    types.addAll(secondaryTypes);

    final copyT = copy(secondaryTypes: types);
    scopeDefinition.remove(this);
    scopeDefinition.save(copyT);
    return copyT;
  }

  ///
  /// OnCloseCallback is called when definition is closed.
  ProviderDefinition<T> onClose(void Function(T value) onDispose,
      {required void Function() onDisposeUnitialized}) {
    final scopeDefinitionCopy = copy(
        onDispose: Callback(
            callback: onDispose,
            callbackForUninitializedValue: onDisposeUnitialized));
    scopeDefinition.remove(this);
    scopeDefinition.save(scopeDefinitionCopy);
    return scopeDefinitionCopy;
  }

  @override
  int get hashCode =>
      primaryType.hashCode ^ qualifier.hashCode ^ scopeDefinition.hashCode;

  @override
  bool operator ==(other) {
    return other is ProviderDefinition &&
        other.primaryType == primaryType &&
        other.qualifier == qualifier &&
        other.scopeDefinition == scopeDefinition;
  }
}

///
/// Converte the 'type' and 'qualifier'
///
String indexKey(Type type, Qualifier? qualifier) {
  var typeString = type.toString();
  if (typeString.endsWith('?')) {
    typeString = typeString.substring(0, typeString.length - 1);
  }

  if (qualifier?.value != null) {
    return '$typeString::${qualifier?.value}';
  } else {
    return typeString;
  }
}
