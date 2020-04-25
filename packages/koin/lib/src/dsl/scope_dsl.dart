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

import 'package:koin/src/core/qualifier.dart';
import 'package:koin/src/core/scope/scope_definition.dart';

import '../core/definition/bean_definition.dart';
import '../core/definition/definitions.dart';
import '../core/definition/options.dart';

class ScopeDSL {
  final ScopeDefinition scopeDefinition;

  ScopeDSL(this.scopeDefinition);

  BeanDefinition<T> scoped<T>(Definition<T> definition,
      {Qualifier qualifier, bool override = false, }) {
    return Definitions.saveSingle<T>(qualifier, definition, scopeDefinition,
        Options(isCreatedAtStart: false, override: override));
  }

  BeanDefinition<T> factory<T>( Definition<T> definition,
      {Qualifier qualifier, bool override = false,}) {
    return Definitions.saveFactory<T>(qualifier, definition, scopeDefinition,
        Options(isCreatedAtStart: false, override: override));
  }
}
