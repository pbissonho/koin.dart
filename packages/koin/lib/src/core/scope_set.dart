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
import 'package:koin/src/core/scope.dart';
import 'package:koin/src/error/exceptions.dart';

import 'definition/bean_definition.dart';
import 'definition/options.dart';

class ScopeSet {
  final Qualifier qualifier;
  var definitions = List<BeanDefinition>();

  ScopeSet([this.qualifier]);

  ScopeSet call() {
    return this;
  }

  BeanDefinition<T> scoped<T>(
    Definition<T> definition,{Qualifier qualifier, bool override}) {
    var beanDefinition =
        BeanDefinition<T>.createScoped(qualifier, this.qualifier, definition);
    declareDefinition(
        beanDefinition, Options(isCreatedAtStart: false, override: override));
    if (!definitions.contains(beanDefinition)) {
      definitions.add(beanDefinition);
    } else {
      throw DefinitionOverrideException(
          "Can't add definition $beanDefinition for scope ${this.qualifier} as it already exists");
    }
    return beanDefinition;
  }

  void declareDefinition<T>(BeanDefinition<T> definition, Options options) {
    definition.options = options;
  }

  BeanDefinition<T> factory<T>(
    Definition<T> definition, {
    Qualifier qualifier,
    bool override}
  ) {
    var beanDefinition =
        BeanDefinition<T>.createFactory(qualifier, this.qualifier, definition);
    declareDefinition(
        beanDefinition, Options(isCreatedAtStart: false, override: override));
    if (!definitions.contains(beanDefinition)) {
      definitions.add(beanDefinition);
    } else {
      throw DefinitionOverrideException(
          "Can't add definition $beanDefinition for scope ${this.qualifier} as it already exists");
    }
    return beanDefinition;
  }

  ScopeDefinition createDefinition() {
    var scopeDefinition = ScopeDefinition(qualifier);
    scopeDefinition.definitions.addAll(definitions);
    return scopeDefinition;
  }

  String toString() {
    return "Scope['$qualifier']";
  }
}

ScopeSet create(Qualifier qualifier) {
  return ScopeSet(qualifier);
}
