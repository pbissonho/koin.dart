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
import 'package:koin/src/core/definition/properties.dart';
import 'package:koin/src/core/definition_parameters.dart';
import 'package:koin/src/core/scope/scope.dart';
import 'package:koin/src/core/scope/scope_definition.dart';

import '../qualifier.dart';
import 'options.dart';

class Callbacks<T> {
  final OnCloseCallback onCloseCallback;

  Callbacks({this.onCloseCallback});
}

typedef OnCloseCallback<T> = void Function(T value);

typedef Definition<T> = T Function(
    Scope scope, DefinitionParameters parameters);

enum Kind {
  Single,
  Factory,
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
  final Definition<T> definition;
  final Kind kind;
  List<Type> secondaryTypes;
  final Options options;
  final Properties _properties = Properties();
  Callbacks callbacks;

  BeanDefinition(
      {this.scopeDefinition,
      this.primaryType,
      this.qualifier,
      this.definition,
      this.kind,
      this.options = const Options(),
      Callbacks callbacks,
      List<Type> secondaryTypes}) {
    if (secondaryTypes == null) {
      this.secondaryTypes = <Type>[];
    } else {
      this.secondaryTypes = secondaryTypes;
    }

    if (callbacks == null) {
      this.callbacks = Callbacks();
    }
  }

  BeanDefinition<T> copy({List<Type> secondaryTypes, Callbacks callbacks}) {
    return BeanDefinition<T>(
        scopeDefinition: scopeDefinition,
        primaryType: primaryType,
        qualifier: qualifier,
        definition: definition,
        kind: kind,
        options: options,
        secondaryTypes: secondaryTypes =
            null ? this.secondaryTypes : secondaryTypes,
        callbacks: callbacks = null ? this.callbacks : callbacks);
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
        qualifier == qualifier &&
        scopeDefinition == scopeDefinition;
  }

  bool canBind(Type primary, Type secondary) {
    return primaryType == primary && secondaryTypes.contains(secondary);
  }
}

String indexKey(Type type, Qualifier qualifier) {
  if (qualifier?.value != null) {
    return '${type.toString()}::${qualifier.value}';
  } else {
    return type.toString();
  }
}
