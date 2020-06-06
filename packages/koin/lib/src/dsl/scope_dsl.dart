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

import '../core/qualifier.dart';
import '../core/scope/scope_definition.dart';

import '../core/definition/bean_definition.dart';
import '../core/definition/definitions.dart';
import '../core/definition/options.dart';
import '../core/definition/definition.dart';

class ScopeDSL {
  final ScopeDefinition scopeDefinition;

  ScopeDSL(this.scopeDefinition);

  BeanDefinition<T> scoped<T>(
    DefinitionFunction<T> definition, {
    Qualifier qualifier,
    bool override = false,
  }) {
    return Definitions.saveSingle<T>(qualifier, DefinitionX<T>(definition),
        scopeDefinition, Options(isCreatedAtStart: false, override: override));
  }

  BeanDefinition<T> scoped1<T, A>(
    DefinitionFunction1<T, A> definition, {
    Qualifier qualifier,
    bool override = false,
  }) {
    return Definitions.saveSingle<T>(qualifier, Definition1<T, A>(definition),
        scopeDefinition, Options(isCreatedAtStart: false, override: override));
  }

  BeanDefinition<T> scoped2<T, A, B>(
    DefinitionFunction2<T, A, B> definition, {
    Qualifier qualifier,
    bool override = false,
  }) {
    return Definitions.saveSingle<T>(
        qualifier,
        Definition2<T, A, B>(definition),
        scopeDefinition,
        Options(isCreatedAtStart: false, override: override));
  }

  BeanDefinition<T> scoped3<T, A, B, C>(
    DefinitionFunction3<T, A, B, C> definition, {
    Qualifier qualifier,
    bool override = false,
  }) {
    return Definitions.saveSingle<T>(
        qualifier,
        Definition3<T, A, B, C>(definition),
        scopeDefinition,
        Options(isCreatedAtStart: false, override: override));
  }

  BeanDefinition<T> factory<T>(
    DefinitionFunction<T> definition, {
    Qualifier qualifier,
    bool override = false,
  }) {
    return Definitions.saveFactory<T>(qualifier, DefinitionX<T>(definition),
        scopeDefinition, Options(isCreatedAtStart: false, override: override));
  }

  BeanDefinition<T> factory1<T, A>(
    DefinitionFunction1<T, A> definition, {
    Qualifier qualifier,
    bool override = false,
  }) {
    return Definitions.saveFactory<T>(qualifier, Definition1<T, A>(definition),
        scopeDefinition, Options(isCreatedAtStart: false, override: override));
  }

  BeanDefinition<T> factory2<T, A, B>(
    DefinitionFunction2<T, A, B> definition, {
    Qualifier qualifier,
    bool override = false,
  }) {
    return Definitions.saveFactory<T>(
        qualifier,
        Definition2<T, A, B>(definition),
        scopeDefinition,
        Options(isCreatedAtStart: false, override: override));
  }

  BeanDefinition<T> factory3<T, A, B, C>(
    DefinitionFunction3<T, A, B, C> definition, {
    Qualifier qualifier,
    bool override = false,
  }) {
    return Definitions.saveFactory<T>(
        qualifier,
        Definition3<T, A, B, C>(definition),
        scopeDefinition,
        Options(isCreatedAtStart: false, override: override));
  }
}
