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

import 'package:koin/src/core/definition/options.dart';
import 'package:koin/src/core/measure.dart';

import '../koin_application.dart';
import '../koin_dart.dart';
import 'definition/bean_definition.dart';
import 'definition_parameters.dart';
import 'error/exceptions.dart';
import 'instance/definition_instance.dart';
import 'lazy/lazy.dart';
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
    return definitions;
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
    return qualifier;
  }

  ScopeDefinition(this.qualifier) : definitions = <BeanDefinition>{};

  @override
  String toString() {
    return 'ScopeDefinition(qualifier = $qualifier)';
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
        callbacks = <ScopeCallback>[];

  ///
  ///Lazy inject a Koin instance
  /// @param qualifier
  /// @param scope
  /// @param parameters
  ///
  /// @return Lazy instance of type T
  ///
  Lazy<T> inject<T>([
    DefinitionParameters parameters,
    Qualifier qualifier,
  ]) {
    parameters ??= emptyParametersHolder();
    return lazy<T>(() => get<T>(qualifier, parameters));
  }

  T call<T>([
    DefinitionParameters parameters,
    Qualifier qualifier,
  ]) {
    parameters ??= emptyParametersHolder();
    return get<T>(qualifier, parameters);
  }

  ///
  /// Get a Koin instance
  /// @param qualifier
  /// @param scope
  /// @param parameters
  ///
  T get<T>([Qualifier qualifier, DefinitionParameters parameters]) {
    var type = T;
    return getWithType(type, qualifier, parameters);
  }

  BeanRegistry getBeanRegistry() {
    return beanRegistry;
  }

  void checkDefinitions() {
    var definitions = beanRegistry.getAllDefinitions();
    definitions.forEach((definition) {
      definition.resolveInstance(InstanceContext(
          koin: koin, scope: this, parameters: parametersOf([])));

      definition.close();
    });
  }

  ScopeDefinition getScopeDefinition() {
    return scopeDefinition;
  }

  void setScopeDefinition(ScopeDefinition definition) {
    scopeDefinition = definition;
  }

  T resolveInstance<T>(
      Type type, Qualifier qualifier, DefinitionParameters parameters) {
    var definition = _findDefinition(type, qualifier);

    return definition.resolveInstance(
        InstanceContext(koin: koin, scope: this, parameters: parameters));
  }

  BeanDefinition _findDefinition(Type type, Qualifier qualifier) {
    var definition = beanRegistry.findDefinition(qualifier, type);

    if (definition != null) return definition;

    if (isRoot) {
      throw NoBeanDefFoundException(
          "No definition for '${type.toString()}' has been found. Check your module definitions.");
    }

    return koin.rootScope._findDefinition(type, qualifier);
  }

  /// Declare a component definition from the given [instance]
  /// This result of declaring a scoped/single definition of type [T], returning the given instance
  /// (single definition of th current scope is root)
  ///
  /// [instance] The instance you're declaring.
  /// [qualifier] Qualifier for this declaration
  /// [secondaryTypes] List of secondary bound types
  /// [override] Allows to override a previous declaration of the same type (default to false).
  ///
  void declare<T>(T instance,
      {Qualifier qualifier, List<Type> secondaryTypes, bool override = false}) {
    BeanDefinition<T> definition;
    if (isRoot) {
      definition =
          BeanDefinition<T>.createSingle(qualifier, null, (s, p) => instance);
    } else {
      definition = BeanDefinition<T>.createScoped(
          qualifier, scopeDefinition.qualifier, (s, p) => instance);
    }

    if (secondaryTypes != null) {
      definition.secondaryTypes.addAll(secondaryTypes);
    }
    definition.options = Options(override: override);
    beanRegistry.saveDefinition(definition);
  }

  T getWithType<T>(
      Type type, Qualifier qualifier, DefinitionParameters parameters) {
    if (KoinApplication.logger.isAt(Level.debug)) {
      // KoinApplication.logger.debug("+- get '${type.toString()}'");
      var result = Measure.measureDuration(() {
        return resolveInstance<T>(type, qualifier, parameters);
      });
      KoinApplication.logger
          .debug("+- get '${type.toString()} in ${result.duration} ms '");
      // KoinApplication.logger
      //     .debug("+- got '${type.toString()}' in ${result.duration} ms");
      return result.result;
    } else {
      return resolveInstance<T>(type, qualifier, parameters);
    }
  }

  void declareDefinitionsFromScopeSet() {
    scopeDefinition.definitions.forEach((definition) {
      beanRegistry.saveDefinition(definition);
      definition.createInstanceHolder();
    });
  }

  ///
  /// Close all instances from this scope
  ///
  void close() {
    if (KoinApplication.logger.isAt(Level.debug)) {
      KoinApplication.logger.info("closing scope:'$id'");
    }

    // call on close from callbacks
    callbacks.forEach((it) => it.onScopeClose(this));
    callbacks.clear();

    scopeDefinition?.release(this);
    beanRegistry.close();
    koin.deleteScope(id);
  }

  @override
  String toString() {
    var scopeDef = 'set: ${scopeDefinition.getQualifier()}';
    return "Scope[id:'$id'$scopeDef]";
  }
}
