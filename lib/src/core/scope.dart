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

import '../koin_application.dart';
import '../koin_dart.dart';
import 'definition/bean_definition.dart';
import 'definition_parameters.dart';
import 'instance/definition_instance.dart';
import 'logger.dart';
import 'qualifier.dart';
import 'registry/bean_register.dart';

abstract class ScopeCallback {
  void onScopeClose(Scope scope);
}

class ScopeDefinition {
  final Set<BeanDefinition> definitions;
  final Qualifier qualifier;

  Set getDefinitions() {
    return this.definitions;
  }

  void release(Scope scopeInstance) {
    definitions.forEach((definition) {
      var definitionInstance = definition.intance;

      if (definitionInstance != null) {
        definitionInstance.release(InstanceContext(scope: scopeInstance));
      }
    });
  }

  Qualifier getQualifier() {
    return this.qualifier;
  }

  ScopeDefinition(this.qualifier) : definitions = Set<BeanDefinition>();

  String toString() {
    return "ScopeDefinition(qualifier = $qualifier)";
  }
}

class Scope {
  final BeanRegistry beanRegistry;
  ScopeDefinition scopeDefinition;
  final List<ScopeCallback> callbacks;

  final String id;
  final bool isRoot;
  final Koin koin;

  Scope({this.id, this.isRoot, this.koin})
      : beanRegistry = BeanRegistry(),
        callbacks = List<ScopeCallback>();

  /**
     * Lazy inject a Koin instance
     * @param qualifier
     * @param scope
     * @param parameters
     *
     * @return Lazy instance of type T
     */
  T inject<T>([
    DefinitionParameters parameters,
    Qualifier qualifier,
  ]) {
    if (parameters == null) {
      parameters = emptyParametersHolder();
    }
    return get<T>(qualifier, parameters);
  }

  /**
     * Get a Koin instance
     * @param qualifier
     * @param scope
     * @param parameters
     */
  T get<T>(Qualifier qualifier, DefinitionParameters parameters) {
    Type type = T;
    return getWithType(type, qualifier, parameters);
  }

  BeanRegistry getBeanRegistry() {
    return this.beanRegistry;
  }

  bool checkDefinitions() {
    var definitions = beanRegistry.getAllDefinitions();
    definitions.forEach((definition) {
      definition.resolveInstance(InstanceContext(
          koin: koin, scope: this, parameters: parametersOf([])));

      definition.close();
    });
  }

  ScopeDefinition getScopeDefinition() {
    return this.scopeDefinition;
  }

  void setScopeDefinition(ScopeDefinition definition) {
    this.scopeDefinition = definition;
  }

  T resolveInstance<T>(
      Type type, Qualifier qualifier, DefinitionParameters parameters) {
    var definition = _findDefinition(type, qualifier);
    return definition.resolveInstance(
        InstanceContext(koin: koin, scope: this, parameters: parameters));
  }

  BeanDefinition _findDefinition(Type type, Qualifier qualifier) {
    var definition = beanRegistry.findDefinition(qualifier, type);

    if (definition != null) {
      return definition;
    } else {
      return koin.rootScope._findDefinition(type, qualifier);
    }

    //throw NoBeanDefFoundException("No definition for '${clazz.getFullName()}' has been found. Check your module definitions.")
  }

  T getWithType<T>(
      Type type, Qualifier qualifier, DefinitionParameters parameters) {
    // Todo
    // Calcular o tempo

    //return if (KoinApplication.logger.isAt(Level.DEBUG)) {
    //  KoinApplication.logger.debug("+- get '${clazz.getFullName()}'")
    //  val (instance: T, duration: Double) = measureDuration {
    //     resolveInstance<T>(qualifier, clazz, parameters)
    // }
    T instance = resolveInstance<T>(type, qualifier, parameters);
    // KoinApplication.logger.debug("+- got '${clazz.getFullName()}' in $duration ms")
    return instance;
    //} else {
    //resolveInstance(qualifier, clazz, parameters);
    //}
  }

  void declareDefinitionsFromScopeSet() {
    scopeDefinition.definitions.forEach((definition) {
      beanRegistry.saveDefinition(definition);
      definition.createInstanceHolder();
    });
  }

  /**
     * Close all instances from this scope
     */
  void close() {
    if (KoinApplication.logger.isAt(Level.debug)) {
      KoinApplication.logger.info("closing scope:'$id'");
    }

    // call on close from callbacks
    callbacks.forEach((it) => it.onScopeClose(this));
    callbacks.clear();

    scopeDefinition?.release(this);
    beanRegistry.close();
    koin.deleteScope(this.id);
  }

  @override
  String toString() {
    var scopeDef = "set: ${scopeDefinition.getQualifier()}";
    return "Scope[id:'$id'$scopeDef]";
  }
}
