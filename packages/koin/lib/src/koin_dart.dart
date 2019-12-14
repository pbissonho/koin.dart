////
/// Copyright 2017-2018 the original author or authors.
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
///      http://www.apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///

import 'package:koin/src/core/koin_component.dart';
import 'package:koin/src/core/logger.dart';
import 'core/definition_parameters.dart';
import 'core/qualifier.dart';
import 'core/registry/scope_register.dart';
import 'core/scope.dart';

///
/// Koin
///
/// Gather main features to use on Koin context
///
/// @author Arnaud Giuliani
/// Ported to Dart from Kotlin by:
/// @author - Pedro Bissonho
///

class Koin {
  ScopeRegistry scopeRegistry = ScopeRegistry();
  //PropertyRegistry propertyRegistry = PropertyRegistry()
  Scope rootScope;

  Koin() {
    rootScope = Scope(id: "-Root-", isRoot: true, koin: this);
  }

  ///
  /// Lazy inject a Koin instance
  ///
  Lazy<T> inject<T>(Qualifier qualifier, DefinitionParameters parameters) {
    return rootScope.inject(parameters, qualifier);
  }

  ///
  /// Lazy inject a Koin instance if available
  ////
  Lazy<T> injectOrNull<T>(
      Qualifier qualifier, DefinitionParameters parameters) {
    // Todo
    // inject or null
    return rootScope.inject(parameters, qualifier);
  }

  ///
  /// Get a Koin instance
  ///
  T get<T>([Qualifier qualifier, DefinitionParameters parameters]) {
    return rootScope.get<T>(
      qualifier,
      parameters,
    );
  }

  ///
  /// Get a Koin instance if available with return instance of type T or null.
  ///
  T getOrNull<T>(Qualifier qualifier, DefinitionParameters parameters) {
    // Todo
    // getOrNull
    return rootScope.get<T>(
      qualifier,
      parameters,
    );
  }

  ///
  /// Get a Koin instance
  /// @return instance of type T
  ///
  T getWithType<T>(
      Type type, Qualifier qualifier, DefinitionParameters parameters) {
    return rootScope.getWithType(type, qualifier, parameters);
  }

  ///
  /// Declare a component definition from the given instance
  /// This result of declaring a single definition of type T, returning the given instance
  ///
  void declare<T>(T instance,
      {Qualifier qualifier, List<Type> secondaryTypes, bool override = false}) {
    rootScope.declare(instance,
        qualifier: qualifier,
        secondaryTypes: secondaryTypes,
        override: override);
  }

  ///
  /// Get a all instance for given inferred class (in primary or secondary type)
  ///
  /// @return list of instances of type T
  ///
  List<T> getAll<T>() {
    // todo
    // => rootScope.getAll()
  }

  ///
  /// Get instance of primary type [P] and return as secondary type [S]
  /// (not for scoped instances)
  ///
  /// @return instance of type [S]
  ///
  S bind<S, P>(DefinitionParameters parameters) {
    //
    //Todo
    //rootScope.bind<S, P>(parameters);
  }

  ///
  /// Get instance of primary type [primaryType] and return as secondary type [S]
  /// (not for scoped instances)
  ///
  /// @return instance of type [S]
  ///
  S bindWithType<S>(
    Type primaryType,
    DefinitionParameters parameters,
    List<Type> secondaryTypes,
  ) {
    // Todo
    //return rootScope.bind(primaryType, secondaryType, parameters);
  }

  void createEagerInstances() {
    // todo
    // rootScope.createEagerInstances();
  }

  ///
  /// Create a Scope instance
  ///
  Scope createScope(String scopeId, Qualifier qualifier) {
    if (logger.isAt(Level.debug)) {
      logger.debug("!- create scope - id:$scopeId q:$qualifier");
    }
    return scopeRegistry.createScopeInstance(this, scopeId, qualifier);
  }

  ///
  /// Get or Create a Scope instance
  ///
  Scope getOrCreateScope(String scopeId, Qualifier qualifier) {
    var scope = scopeRegistry.getScopeInstanceOrNull(scopeId);
    if (scope == null) {
      return createScope(scopeId, qualifier);
    }
  }

  ///
  /// Get a scope instance by id.
  ///
  Scope getScope(String scopeId) {
    return scopeRegistry.getScopeInstance(scopeId);
  }

  ///
  /// get a scope instance
  /// @param scopeId
  ///
  Scope getScopeOrNull(String scopeId) {
    return scopeRegistry.getScopeInstanceOrNull(scopeId);
  }

  ///
  /// Delete a scope instance
  ///
  void deleteScope(String scopeId) {
    scopeRegistry.deleteScopeInstance(scopeId);
  }

  /*
    ///
    /// Retrieve a property
    /// @param key
    /// @param defaultValue
    T <T> getProperty(key: String, defaultValue: T): T {
        return propertyRegistry.getProperty<T>(key) ?: defaultValue
    }

    /// Retrieve a property
    /// @param key
    ///
    fun <T> getProperty(key: String): T? {
        return propertyRegistry.getProperty(key)
    }
  
    ///
    /// Save a property
    /// @param key
    /// @param value
    ///
    fun <T : Any> setProperty(key: String, value: T) {
        propertyRegistry.saveProperty(key, value)
    }
  
  */

  ///
  /// Close all resources from context
  ///
  void close() {
    scopeRegistry.close();
    rootScope.close();
    // propertyRegistry.close();
  }
}
