import 'definition_parameter.dart';

import 'internal/exceptions.dart';
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

import 'logger.dart';
import 'module.dart';
import 'package:kt_dart/kt.dart';
import 'observer.dart';
import 'scope/scope_definition.dart';
import '../scope_instance.dart';
import 'lazy.dart';
import 'qualifier.dart';
import 'registry/scope_registry.dart';
import 'scope/scope.dart';

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
  Logger logger;
  LoggerInstanceObserverBase loggerInstanceObserver;
  final KtHashSet<Module> _modules = KtHashSet<Module>.empty();

  ScopeRegistry get scopeRegistry => _scopeRegistry;

  Koin() {
    _scopeRegistry = ScopeRegistry(this);
    logger = EmptyLogger(Level.debug);
    loggerInstanceObserver = LoggerInstanceObserver(this);
  }

  ///
  /// Lazy inject a Koin instance
  ///
  Lazy<T> inject<T>([Qualifier qualifier, DefinitionParameter parameters]) {
    return _scopeRegistry.rootScope.inject(qualifier);
  }

  ///
  /// Lazy inject a Koin instance
  ///
  Lazy<T> injectWithParam<T, P>(P param, {Qualifier qualifier}) {
    return _scopeRegistry.rootScope
        .injectWithParam<T, P>(param, qualifier: qualifier);
  }

  ///
  /// Lazy inject a Koin instance if available.
  /// Return Lazy instance of type T or null.
  ////
  Lazy<T> injectOrNull<T>(Qualifier qualifier, DefinitionParameter parameters) {
    return _scopeRegistry.rootScope.injectOrNull(parameters, qualifier);
  }

  ///
  /// Get a Koin instance
  ///
  T get<T>([Qualifier qualifier]) {
    return _scopeRegistry.rootScope.get<T>(
      qualifier,
    );
  }

  ///
  /// Get a Koin instance
  ///
  T getWithParam<T, P>(P parameter, {Qualifier qualifier}) {
    return _scopeRegistry.rootScope.getWithParam<T, P>(
      parameter,
      qualifier: qualifier,
    );
  }

  ///
  /// Get a Koin instance if available with return instance of type T or null.
  ///
  T getOrNull<T>([Qualifier qualifier, DefinitionParameter parameters]) {
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
      [Type type, Qualifier qualifier, DefinitionParameter parameters]) {
    return _scopeRegistry.rootScope.getWithType<T>(type, qualifier, parameters);
  }

  ///
  /// Get a Koin instance if available
  T getOrNullWithType<T>(
      [Type type, Qualifier qualifier, DefinitionParameter parameters]) {
    return _scopeRegistry.rootScope
        .getWithTypeOrNull(type, qualifier, parameters);
  }

  ///
  /// Declare a component definition from the given instance
  /// This result of declaring a single definition of type T, returning
  /// the given instance
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
  S bind<S, P>([DefinitionParameter parameters]) {
    return _scopeRegistry.rootScope.bind<S, P>(parameters);
  }

  ///
  /// Get instance of primary type [primaryType] and return as secondary
  /// type [S]
  /// (not for scoped instances)
  ///
  /// @return instance of type [S]
  ///
  S bindWithType<S>(Type secondaryType, Type primaryType,
      [DefinitionParameter parameters]) {
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
  Scope createScope<T>(String scopeId, [dynamic source]) {
    var qualifier = TypeQualifier(T);
    logger.isAtdebug('!- create scope - id:$scopeId q:$qualifier', Level.debug);
    return _scopeRegistry.createScope(scopeId, qualifier, source);
  }

  // Returns whether or not there is a definition for [qualifier].
  Scope createScopeWithQualifier(String scopeId, Qualifier qualifier,
      [dynamic source]) {
    logger.isAtdebug('!- create scope - id:$scopeId q:$qualifier', Level.debug);
    return _scopeRegistry.createScope(scopeId, qualifier, source);
  }

  ///
  /// Create a Scope instance
  ///
  Scope createScopeWithSource<T>(String scopeId, dynamic source) {
    var qualifier = TypeQualifier(T);
    logger.isAtdebug('!- create scope - id:$scopeId q:$qualifier', Level.debug);
    return _scopeRegistry.createScope(scopeId, qualifier, source);
  }

  Scope createScopeT2<T>() {
    var type = T;
    var scopeId = type.scopeId;
    var qualifier = TypeQualifier(T);

    logger.isAtdebug('!- create scope - id:$scopeId q:$qualifier', Level.debug);

    return _scopeRegistry.createScope(scopeId, qualifier, null);
  }

  ///
  /// Get or Create a Scope instance
  ///
  Scope getOrCreateScope<T>(String scopeId) {
    var scope = _scopeRegistry.getScopeOrNull(scopeId);
    if (scope == null) {
      return createScopeWithQualifier(scopeId, named<T>());
    }
    return scope;
  }

  ///
  /// Get or Create a Scope instance
  ///
  Scope getOrCreateScopeQualifier(String scopeId, Qualifier qualifier) {
    var scope = _scopeRegistry.getScopeOrNull(scopeId);
    if (scope == null) {
      return createScopeWithQualifier(scopeId, qualifier);
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

  ///
  /// Close all resources from context
  ///
  void close() {
    _modules.forEach((m) {
      m.isLoaded = false;
    });
    _modules.clear();
    _scopeRegistry.close();
  }

  void loadModules(List<Module> modules) {
    _modules.addAll(KtHashSet.from(modules));
    _scopeRegistry.loadModules(modules);
  }

  void loadModule(Module module) {
    _modules.add(module);
    _scopeRegistry.loadModule(module);
  }

  void loadScopeDefinition(ScopeDefinition scopeDefinition) {
    _scopeRegistry.declareScope(scopeDefinition);
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
}
