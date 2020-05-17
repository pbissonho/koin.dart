///
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
////

import 'package:koin/src/core/error/exceptions.dart';
import 'package:koin/src/core/measure.dart';
import 'package:koin/src/core/registry/instance_registry.dart';
import 'package:kt_dart/kt.dart';

import '../definition/bean_definition.dart';
import '../lazy/lazy.dart';
import '../koin_dart.dart';
import '../definition_parameters.dart';
import '../logger.dart';
import '../qualifier.dart';
import 'scope_callback.dart';
import 'scope_definition.dart';

class Scope {
  final String id;
  final ScopeDefinition scopeDefinition;
  final Koin koin;
  final dynamic source;

  final KtHashSet<Scope> _linkedScope = KtHashSet<Scope>.empty();
  InstanceRegistry _instanceRegistry;
  InstanceRegistry get instanceRegistry => _instanceRegistry;
  bool _closed = false;

  bool get closed => _closed;
  List<ScopeCallback> callbacks = <ScopeCallback>[];

  Scope({this.id, this.koin, this.scopeDefinition, this.source}) {
    _instanceRegistry = InstanceRegistry(koin, this);
  }

  void create(KtList<Scope> links) {
    _instanceRegistry
        .create(KtHashSet.from(scopeDefinition.definitions.asSet()));
    _linkedScope.addAll(links);
  }

  T getSource<T>() {
    if (source is T) {
      return source as T;
    } else {
      throw IllegalStateException(
          "Can't use Scope source for ${T} - source is:$source");
    }
  }

  ///
  /// Add parent Scopes to allow instance resolution
  ///i.e: linkTo(scopeC) - allow to resolve instance to current scope and scopeC
  ///
  /// @param scopes - Scopes to link with
  ///
  void linkTo(List<Scope> scopes) {
    if (!scopeDefinition.isRoot) {
      _linkedScope.addAll(KtList.from(scopes));
    } else {
      throw IllegalStateException("Can't add scope link to a root scope");
    }
  }

  ///
  /// Remove linked scope
  ////
  void unlink(List<Scope> scopes) {
    if (!scopeDefinition.isRoot) {
      _linkedScope.removeAll((KtList.from(scopes)));
    } else {
      throw IllegalStateException("Can't remove scope link to a root scope");
    }
  }

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

  ///
  /// Lazy inject a Koin instance if available
  ///@param qualifier
  /// @param scope
  /// @param parameters
  ///
  ///@return Lazy instance of type T or null
  ///
  Lazy<T> injectOrNull<T>([
    DefinitionParameters parameters,
    Qualifier qualifier,
  ]) {
    parameters ??= emptyParametersHolder();
    return lazy<T>(() => getOrNull<T>(qualifier, parameters));
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

  T getParams<T>({Qualifier qualifier, DefinitionParameters parameters}) {
    var type = T;
    return getWithType(type, qualifier, parameters);
  }

  ///
  /// Get a Koin instance if available
  /// @param qualifier
  ///@param scope
  /// @param parameters
  ///
  ///@return instance of type T or null
  ///
  T getOrNull<T>([Qualifier qualifier, DefinitionParameters parameters]) {
    var type = T;
    return getWithTypeOrNull(type, qualifier, parameters);
  }

  ///
  /// Get a Koin instance if available
  /// @param qualifier
  /// @param scope
  /// @param parameters
  ///
  /// @return instance of type T or null
  ///
  T getWithTypeOrNull<T>(
      Type type, Qualifier qualifier, DefinitionParameters parameters) {
    try {
      return getWithType(type, qualifier, parameters);
    } catch (e) {
      koin.logger.error("Can't get instance for ${type}");
      return null;
    }
  }

  ///
  /// Get a Koin instance
  /// @param clazz
  /// @param qualifier
  /// @param parameters
  ///
  /// @return instance of type T
  ///
  T getWithType<T>(
      Type type, Qualifier qualifier, DefinitionParameters parameters) {
    if (koin.logger.isAt(Level.debug)) {
      // KoinApplication.logger.debug("+- get '${type.toString()}'");
      var result = Measure.measureDuration(() {
        return resolveInstance<T>(type, qualifier, parameters);
      });
      koin.logger
          .debug("+- get '${type.toString()} in ${result.duration} ms '");
      // KoinApplication.logger
      //     .debug("+- got '${type.toString()}' in ${result.duration} ms");
      return result.result;
    } else {
      return resolveInstance<T>(type, qualifier, parameters);
    }
  }

  T resolveInstance<T>(
      Type type, Qualifier qualifier, DefinitionParameters parameters) {
    if (_closed) {
      throw ClosedScopeException('Scope $id is closed');
    }

    var indexKeyCurrent = indexKey(type, qualifier);

    var instance =
        _instanceRegistry.resolveInstance<T>(indexKeyCurrent, parameters);

    if (instance == null) {
      var inOtherScope = findInOtherScope<T>(type, qualifier, parameters);

      if (inOtherScope == null) {
        var fromSource = getFromSource(type);

        if (fromSource == null) {
          var qualifierString =
              qualifier != null ? " & qualifier:'$qualifier'" : '';
          throw NoBeanDefFoundException(
              "No definition found for class:'${type}'$qualifierString. Check your definitions!");
        }
      } else {
        return inOtherScope;
      }
    } else {
      return instance;
    }
  }

  T getFromSource<T>(Type type) {
    if (type == source.runtimeType) {
      return source as T;
    } else {
      null;
    }
  }

  T findInOtherScope<T>(
      Type type, Qualifier qualifier, DefinitionParameters parameters) {
    var scope = _linkedScope.firstOrNull((scope) =>
        scope.getWithTypeOrNull<T>(type, qualifier, parameters) != null);

    return scope?.getWithType(type, qualifier, parameters);
  }

  void createEagerInstances() {
    if (scopeDefinition.isRoot) {
      _instanceRegistry.createEagerInstances();
    }
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
    var definition = scopeDefinition.saveNewDefinition(
        instance, qualifier, secondaryTypes, override);
    _instanceRegistry.saveDefinition(definition, override: true);
  }

  ///
  ///Get current Koin instance
  ///
  Koin getKoin() => koin;

  ///
  /// Get Scope
  ///@param scopeID
  ///
  Scope getScope(String scopeID) => getKoin().getScope(scopeID);

  ///
  /// Register a callback for this Scope Instance
  ///
  void registerCallback(ScopeCallback callback) {
    callbacks.add(callback);
  }

  ///
  ///Get a all instance for given inferred class (in primary or secondary type)
  ///
  /// @return list of instances of type T
  ///
  List<T> getAll<T>() => getAllWithType(T);

  ///
  /// Get a all instance for given class (in primary or secondary type)
  /// @param clazz T
  ///
  /// @return list of instances of type T
  ///
  List<T> getAllWithType<T>(Type type) => _instanceRegistry.getAll(type);

  ///
  /// Get instance of primary type P and secondary type S
  /// (not for scoped instances)
  ///
  ///@return instance of type S
  ///
  S bind<S, P>(DefinitionParameters parameters) {
    var secondaryType = S.runtimeType;
    var primaryType = P.runtimeType;
    return bindWithType(primaryType, secondaryType, parameters);
  }

  ///
  /// Get instance of primary type P and secondary type S
  /// (not for scoped instances)
  ///
  /// @return instance of type S
  ///
  S bindWithType<S>(
      Type primaryType, Type secondaryType, DefinitionParameters parameters) {
    S definition =
        _instanceRegistry.bind(primaryType, secondaryType, parameters);

    if (definition == null) {
      throw NoBeanDefFoundException(
          "No definition found to bind class:'${primaryType.toString()}' & secondary type:'${secondaryType.toString()}'. Check your definitions!");
    } else {
      return definition;
    }
  }

  ///
  /// Retrieve a property
  /// @param key
  /// @param defaultValue
  ///
  T getProperty<T>(String key, T defaultValue) {
    return koin.getProperty(key, defaultValue);
  }

  ///
  /// Retrieve a property
  /// @param key
  ///
  // TODO
  T getPropertyOrNull<T>(String key) {
    return koin.getPropertyOrNull(key);
  }

  ///
  /// Retrieve a property
  /// @param key
  ///
  // TODO
  T getPropertyWithException<T>(String key) {
    var property = koin.getPropertyOrNull(key);

    if (property == null) {
      throw MissingPropertyException("Property '$key' not found");
    } else {
      return property;
    }
  }

  ///
  /// Close all instances from this scope
  ///
  void close() {
    clear();
    koin.scopeRegistry.deleteScope(this);
  }

  void clear() {
    _closed = true;
    if (koin.logger.isAt(Level.debug)) {
      koin.logger.info("closing scope:'$id'");
    }
    // call on close from callbacks
    callbacks.forEach((callback) {
      callback.onScopeClose(this);
    });
    callbacks.clear();

    _instanceRegistry.close();
  }

  @override
  String toString() {
    return "['$id']";
  }

  void dropInstances(ScopeDefinition scopeDefinition) {
    scopeDefinition.definitions.forEach((definition) {
      _instanceRegistry.dropDefinition(definition);
    });
  }

  void loadDefinitions(ScopeDefinition scopeDefinition) {
    scopeDefinition.definitions.forEach((definition) {
      _instanceRegistry.createDefinition(definition);
    });
  }
}
