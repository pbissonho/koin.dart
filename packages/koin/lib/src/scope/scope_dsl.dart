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

import '../qualifier.dart';
import '../scope/scope_definition.dart';

import '../definition/provider_definition.dart';
import '../definition/definitions.dart';
import '../definition/definition.dart';

class ScopeDSL {
  final ScopeDefinition scopeDefinition;

  ScopeDSL(this.scopeDefinition);

  ProviderDefinition<T> scoped<T>(
    ProviderCreate<T> create, {
    Qualifier qualifier,
    bool override = false,
  }) {
    return Definitions.saveSingle<T>(
        qualifier,
        ProviderCreateDefinition<T>(create),
        scopeDefinition,
        Options(isCreatedAtStart: false, override: override));
  }

  ProviderDefinition<T> scopedWithParam<T, A>(
    DefinitionFunctionWithParam<T, A> definition, {
    Qualifier qualifier,
    bool override = false,
  }) {
    return Definitions.saveSingle<T>(
        qualifier,
        DefinitionWithParam<T, A>(definition),
        scopeDefinition,
        Options(isCreatedAtStart: false, override: override));
  }

  ProviderDefinition<T> factory<T>(
    ProviderCreate<T> create, {
    Qualifier qualifier,
    bool override = false,
  }) {
    return Definitions.saveFactory<T>(
        qualifier,
        ProviderCreateDefinition<T>(create),
        scopeDefinition,
        Options(isCreatedAtStart: false, override: override));
  }

  ProviderDefinition<T> factoryWithParam<T, A>(
    DefinitionFunctionWithParam<T, A> definition, {
    Qualifier qualifier,
    bool override = false,
  }) {
    return Definitions.saveFactory<T>(
        qualifier,
        DefinitionWithParam<T, A>(definition),
        scopeDefinition,
        Options(isCreatedAtStart: false, override: override));
  }
}
