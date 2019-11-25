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

import 'package:koin/src/core/definition/bean_definition.dart';
import 'package:koin/src/core/instance/scope_definition_instance.dart';
import 'package:koin/src/core/instance/singleton_definition_instance.dart';
import 'package:koin/src/error/error.dart';
import 'package:koin/src/error/exceptions.dart';

import '../definition_parameters.dart';
import '../logger.dart';
import '../qualifier.dart';
import 'factory_definition_instance.dart';

///
/// Instance resolution Context
/// Help support DefinitionContext & DefinitionParameters when resolving definition function
///
class InstanceContext {
  Koin koin;
  Scope scope;
  DefinitionParameters _parameters;

  InstanceContext({this.koin, this.scope, DefinitionParameters parameters}) {
    if (parameters == null) {
      _parameters = emptyParametersHolder();
    }
    _parameters = parameters;
  }

  DefinitionParameters get getParameters => _parameters;
  Scope get getScope => scope;
  Koin get getKoin => koin;
}

class Scope {
  get scopeDefinition => null;

  Object get id => null;
}

class Koin {
  get rootScope => null;
}

///
/// Koin Instance Holder
/// create/get/release an instance of given definition
///
abstract class DefinitionInstance<T> {
  final BeanDefinition<T> beanDefinition;

  DefinitionInstance(this.beanDefinition);

  ///
  /// Retrieve an instance
  /// @param context
  /// @return T
  ///
  T get(InstanceContext context);

  ///
  /// Create an instance
  /// @param context
  /// @return T
  ///
  T create(InstanceContext context) {
    if (logger.isAt(Level.debug)) {
      logger.debug("| create instance for $beanDefinition");
    }

    try {
      var parameters = context.getParameters;
      if (context.scope == null) {
        error(
            "Can't execute definition instance while this context is not registered against any Koin instance");
      }
      var result = beanDefinition.definition(context.scope, parameters);
      return result;
    } catch (e) {
      logger.error(
          "Instance creation error : could not create instance for $beanDefinition: ${e.toString()}");
      throw InstanceCreationException(
          "Could not create instance for $beanDefinition", e);
    }
  }

  /// Is instance created
  bool isCreated(InstanceContext context);

  ///
  /// Release the held instance (if hold)
  ///
  void release(InstanceContext context);

  ///
  /// close the instance allocation from registry
  ///
  void close();

  factory DefinitionInstance.factory(BeanDefinition<T> beanDefinition) {
    return FactoryDefinitionInstance<T>(beanDefinition);
  }

  factory DefinitionInstance.scoped(BeanDefinition<T> beanDefinition) {
    return ScopeDefinitionInstance<T>(beanDefinition);
  }

  factory DefinitionInstance.single(BeanDefinition<T> beanDefinition) {
    return SingleDefinitionInstance<T>(beanDefinition);
  }
}

void checkScopeResolution(BeanDefinition definition, Scope scope) {
  Qualifier scopeInstanceName = scope.scopeDefinition?.qualifier;
  Qualifier beanScopeName = definition.scopeName;
  if (beanScopeName != scopeInstanceName) {
    if (scopeInstanceName == null) {
      throw BadScopeInstanceException(
          "Can't use definition $definition defined for scope '$beanScopeName', with an open scope instance $scope. Use a scope instance with scope '$beanScopeName'");
    }

    if (beanScopeName == null) {
      throw BadScopeInstanceException(
          "Can't use definition $definition defined for scope '$beanScopeName' with scope instance $scope. Use a scope instance with scope '$beanScopeName'.");
    }
  }
}
