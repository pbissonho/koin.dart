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

import 'package:koin/src/core/logger.dart';
import 'package:koin/src/core/module.dart';
import 'package:kt_dart/kt.dart';

import 'definition_parameters.dart';
import 'error/exceptions.dart';
import 'lazy/lazy.dart';
import 'qualifier.dart';
import 'registry/proterty_registry.dart';
import 'registry/scope_registry.dart';
import 'scope/scope.dart';
import '../ext/instance_scope_ext.dart';

/// Koin
///
/// Gather main features to use on Koin context
///
/// @author Arnaud Giuliani
/// Ported to Dart from Kotlin by:
/// @author - Pedro Bissonho
///

class Koin {
  ScopeRegistry _scopeRegistry;
  PropertyRegistry _propertyRegistry;
  Logger _logger;
  final KtHashSet<Module> _modules = KtHashSet<Module>.empty();

  Logger get logger => _logger;
  set logger(logger) => _logger = logger;
  ScopeRegistry get scopeRegistry => _scopeRegistry;

  Koin() {
    _scopeRegistry = ScopeRegistry(this);
    _propertyRegistry = PropertyRegistry(this);
    _logger = EmptyLogger(Level.debug);
  }

  ///
  /// Lazy inject a Koin instance
  ///
  Lazy<T> inject<T>([Qualifier qualifier, DefinitionParameters parameters]) {
    return _scopeRegistry.rootScope.inject(parameters, qualifier);
  }

  ///
  /// Lazy inject a Koin instance if available.
  /// Return Lazy instance of type T or null.
  ////
  Lazy<T> injectOrNull<T>(
      Qualifier qualifier, DefinitionParameters parameters) {
    return _scopeRegistry.rootScope.injectOrNull(parameters, qualifier);
  }

  ///
  /// Get a Koin instance
  ///
  T get<T>([Qualifier qualifier, DefinitionParameters parameters]) {
    return _scopeRegistry.rootScope.get<T>(
      qualifier,
      parameters,
    );
  }

  ///
  /// Get a Koin instance
  ///
  T getWithParams<T>({Qualifier qualifier, DefinitionParameters parameters}) {
    return _scopeRegistry.rootScope.get<T>(
      qualifier,
      parameters,
    );
  }

  ///
  /// Get a Koin instance if available with return instance of type T or null.
  ///
  T getOrNull<T>([Qualifier qualifier, DefinitionParameters parameters]) {
    return _scopeRegistry.rootScope.getOrNull<T>(
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
    return _scopeRegistry.rootScope.getWithType<T>(type, qualifier, parameters);
  }

  ///
  /// Get a Koin instance if available
  T getOrNullWithType<T>(
      Type type, Qualifier qualifier, DefinitionParameters parameters) {
    return _scopeRegistry.rootScope
        .getWithTypeOrNull(type, qualifier, parameters);
  }

  ///
  /// Declare a component definition from the given instance
  /// This result of declaring a single definition of type T, returning the given instance
  ///
  void declare<T>(T instance,
      {Qualifier qualifier,
      List<Type> secondaryTypes = const <Type>[],
      bool override = false}) {
    var firstType = T;
    var types = List.of([firstType]);
    types.addAll(secondaryTypes);

    _scopeRegistry.rootScope.declare(instance,
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
    return _scopeRegistry.rootScope.getAll<T>();
  }

  ///
  /// Get instance of primary type [P] and return as secondary type [S]
  /// (not for scoped instances)
  ///
  /// @return instance of type [S]
  ///
  S bind<S, P>(DefinitionParameters parameters) {
    return _scopeRegistry.rootScope.bind<S, P>(parameters);
  }

  ///
  /// Get instance of primary type [primaryType] and return as secondary type [S]
  /// (not for scoped instances)
  ///
  /// @return instance of type [S]
  ///
  S bindWithType<S>(
    Type primaryType,
    Type secondaryType,
    DefinitionParameters parameters,
  ) {
    return _scopeRegistry.rootScope
        .bindWithType(primaryType, secondaryType, parameters);
  }

  void createEagerInstances() {
    createContextIfNeeded();
    _scopeRegistry.rootScope.createEagerInstances();
  }

  void createContextIfNeeded() {
    if (_scopeRegistry.rootScope == null) {
      _scopeRegistry.createRootScope();
    }
  }

  ///
  /// Create a Scope instance
  ///
  Scope createScope(String scopeId, Qualifier qualifier, [dynamic source]) {
    if (logger.isAt(Level.debug)) {
      logger.debug('!- create scope - id:$scopeId q:$qualifier');
    }
    return _scopeRegistry.createScope(scopeId, qualifier, source);
  }

  ///
  /// Create a Scope instance
  ///
  Scope createScopeT<T>(String scopeId, dynamic source) {
    var qualifier = TypeQualifier(T);
    if (logger.isAt(Level.debug)) {
      logger.debug('!- create scope - id:$scopeId q:$qualifier');
    }
    return _scopeRegistry.createScope(scopeId, qualifier, source);
  }

  Scope createScopeT2<T>() {
    var type = T;
    var scopeId = type.scopeId;
    var qualifier = TypeQualifier(T);
    if (logger.isAt(Level.debug)) {
      logger.debug('!- create scope - id:$scopeId q:$qualifier');
    }
    return _scopeRegistry.createScope(scopeId, qualifier, null);
  }

  // TODO
  /*
   /// 
  /// Create a Scope instance
  ///
  Scope createScopeTS<T>() {
    var type = T;
    var scopeId = type.

    var qualifier = TypeQualifier(T);
    if (logger.isAt(Level.debug)) {
      logger.debug('!- create scope - id:$scopeId q:$qualifier');
    }
    return _scopeRegistry.createScope(scopeId, qualifier, source);
  }*/

  ///
  /// Get or Create a Scope instance
  ///
  Scope getOrCreateScope(String scopeId, Qualifier qualifier) {
    var scope = _scopeRegistry.getScopeOrNull(scopeId);
    if (scope == null) {
      return createScopeT(scopeId, qualifier);
    }
    return scope;
  }

  ///
  /// Get or Create a Scope instance
  ///
  Scope getOrCreateScopeT<T>(String scopeId) {
    var qualifier = TypeQualifier(T);
    var scope = _scopeRegistry.getScopeOrNull(scopeId);
    if (scope == null) {
      return createScopeT(scopeId, qualifier);
    }
    return scope;
  }

  ///
  /// Get a scope instance by id.
  ///
  Scope getScope(String scopeId) {
    var scope = _scopeRegistry.getScopeOrNull(scopeId);
    if (scope == null) {
      throw ScopeNotCreatedException("No scope found for id '$scopeId'");
    } else {
      return scope;
    }
  }

  ///
  /// get a scope instance
  /// @param scopeId
  ///
  Scope getScopeOrNull(String scopeId) {
    return _scopeRegistry.getScopeOrNull(scopeId);
  }

  ///
  /// Delete a scope instance
  ///
  void deleteScope(String scopeId) {
    _scopeRegistry.deleteScopeByID(scopeId);
  }

  /*

  /**
     * Retrieve a property
     * @param key
     * @param defaultValue
     */
    fun <T> getProperty(key: String, defaultValue: T): T {
        return _propertyRegistry.getProperty<T>(key) ?: defaultValue
    }

    /**
     * Retrieve a property
     * @param key
     */
    fun <T> getProperty(key: String): T? {
        return _propertyRegistry.getProperty(key)
    }

    /**
     * Save a property
     * @param key
     * @param value
     */
    fun <T : Any> setProperty(key: String, value: T) {
        _propertyRegistry.saveProperty(key, value)
    }

    /**
     * Delete a property
     * @param key
     */
    fun deleteProperty(key: String) {
        _propertyRegistry.deleteProperty(key)
    }
*/

  ///
  ///Close all resources from context
  //
  void close() {
    _modules.forEach((m) {
      m.isLoaded = false;
    });
    _modules.clear();
    _scopeRegistry.close();
    //_propertyRegistry.close()
  }

  void loadModules(List<Module> modules) {
    _modules.addAll(KtHashSet.from(modules));
    _scopeRegistry.loadModules(modules);
  }

  void loadModule(Module module) {
    _modules.add(module);
    _scopeRegistry.loadModule(module);
  }

  void unloadModule(Module module) {
    _scopeRegistry.unloadModule(module);
    _modules.remove(module);
  }

  void unloadModules(List<Module> modules) {
    _scopeRegistry.unloadModules(modules);
    _modules.removeAll(KtHashSet.from(modules));
  }

  void createRootScope() {
    _scopeRegistry.createRootScope();
  }

  getProperty(String key, defaultValue) {}

  getPropertyOrNull(String key) {}
}
