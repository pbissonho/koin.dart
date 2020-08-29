import '../internal/exceptions.dart';
import '../instance/instance_factory.dart';

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
///

import '../measure.dart';
import '../registry/instance_registry.dart';
import 'package:kt_dart/kt.dart';

import '../definition/bean_definition.dart';
import '../lazy.dart';
import '../koin_dart.dart';
import '../definition_parameter.dart';

import '../logger.dart';
import '../qualifier.dart';
import 'scope_definition.dart';

abstract class ScopeCallback {
  void onScopeClose();
}

class Scope {
  final String id;
  final ScopeDefinition scopeDefinition;
  final Koin koin;
  final dynamic source;

  final KtHashSet<Scope> _linkedScope = KtHashSet<Scope>.empty();
  InstanceRegistry _instanceRegistry;
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
          "Can't use Scope source for $T - source is:$source");
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
    Qualifier qualifier,
  ]) {
    return lazy<T>(() {
      final type = T;
      return getWithType(type, qualifier, emptyParameter());
    });
  }

  ///
  ///Lazy inject a Koin instance
  /// @param qualifier
  /// @param scope
  /// @param parameters
  ///
  /// @return Lazy instance of type T
  ///
  Lazy<T> injectWithParam<T, P>(
    P parameter, {
    Qualifier qualifier,
  }) {
    return lazy<T>(() {
      final type = T;
      return getWithType(type, qualifier, DefinitionParameter(parameter));
    });
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
    DefinitionParameter definitionParameter,
    Qualifier qualifier,
  ]) {
    return lazy<T>(() => getOrNull<T>(qualifier, definitionParameter));
  }

  ///
  /// Get a Koin instance
  /// @param qualifier
  /// @param scope
  /// @param parameters
  ///
  T get<T>([Qualifier qualifier]) {
    final type = T;
    return getWithType(type, qualifier, emptyParameter());
  }

  T getWithParam<T, P>(P parameter, {Qualifier qualifier}) {
    final type = T;
    return getWithType(type, qualifier, DefinitionParameter<P>(parameter));
  }

  ///
  /// Get a Koin instance if available
  /// @param qualifier
  ///@param scope
  /// @param parameters
  ///
  ///@return instance of type T or null
  ///
  T getOrNull<T>(
      [Qualifier qualifier, DefinitionParameter definitionParameter]) {
    final type = T;
    return getWithTypeOrNull(type, qualifier, definitionParameter);
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
      Type type, Qualifier qualifier, DefinitionParameter definitionParameter) {
    try {
      return getWithType(type, qualifier, definitionParameter);
    } catch (e) {
      koin.logger.error("Can't get instance for $type");
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
      Type type, Qualifier qualifier, DefinitionParameter definitionParameter) {
    if (koin.logger.isAt(Level.debug)) {
      final result = Measure.measureDuration(() {
        return resolveInstance<T>(type, qualifier, definitionParameter);
      });
      koin.loggerInstanceObserver
          .onResolve(type.toString(), result.duration.toString());
      return result.result;
    } else {
      return resolveInstance<T>(type, qualifier, definitionParameter);
    }
  }

  T resolveInstance<T>(
      Type type, Qualifier qualifier, DefinitionParameter definitionParameter) {
    if (_closed) {
      throw ClosedScopeException('Scope $id is closed');
    }

    definitionParameter ??= emptyParameter();

    final indexKeyCurrent = indexKey(type, qualifier);

    final instance = _instanceRegistry.resolveInstance<T>(
        indexKeyCurrent, definitionParameter);

    if (instance != null) return instance;
    final inOtherScope =
        findInOtherScope<T>(type, qualifier, definitionParameter);
    if (inOtherScope != null) return inOtherScope;

    final fromSource = getFromSource<T>(type);

    if (fromSource == null) {
      final qualifierString =
          qualifier != null ? " & qualifier:'$qualifier'" : '';
      throw NoBeanDefFoundException("""
No definition found for class:'$type'$qualifierString. Check your definitions!""");
    }
    return fromSource;
  }

  T getFromSource<T>(Type type) {
    if (type == source.runtimeType) {
      return source as T;
    } else {
      return null;
    }
  }

  T findInOtherScope<T>(
      Type type, Qualifier qualifier, DefinitionParameter definitionParameter) {
    final scope = _linkedScope.firstOrNull((scope) =>
        scope.getWithTypeOrNull<T>(type, qualifier, definitionParameter) !=
        null);

    return scope?.getWithType(type, qualifier, definitionParameter);
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
  /// [override] Allows to override a previous declaration of the same type
  /// (default to false).
  ///
  void declare<T>(T instance,
      {Qualifier qualifier, List<Type> secondaryTypes, bool override = false}) {
    var definition = scopeDefinition.saveNewDefinition(
        instance, qualifier, secondaryTypes,
        override: override);
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
  List<T> getAllWithType<T>(Type type) => _instanceRegistry.getAllByType(type);

  /// Returns all InstanceFactory's scope.
  KtList<InstanceFactory> getAllInstanceFactory<T>() {
    return _instanceRegistry.getAllFactoryAsList();
  }

  ///
  /// Get instance of primary type P and secondary type S
  /// (not for scoped instances)
  ///
  ///@return instance of type S
  ///
  S bind<S, P>([DefinitionParameter definitionParameter]) {
    return bindWithType(P, S, definitionParameter);
  }

  ///
  /// Get instance of primary type P and secondary type S
  /// (not for scoped instances)
  ///
  /// @return instance of type S
  ///
  S bindWithType<S>(Type primaryType, Type secondaryType,
      DefinitionParameter definitionParameter) {
    var definition =
        _instanceRegistry.bind(primaryType, secondaryType, definitionParameter);

    if (definition == null) {
      throw NoBeanDefFoundException("""
      No definition found to bind class:'${primaryType.toString()}' & secondary 
      type:'${secondaryType.toString()}'. Check your definitions!""");
    } else {
      return definition;
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
    koin.logger.isAtInfo("closing scope:'$id'", Level.debug);

    // call on close from callbacks
    callbacks.forEach((callback) {
      callback.onScopeClose();
    });
    callbacks.clear();

    _instanceRegistry.close();
  }

  @override
  String toString() {
    return '[$id]';
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
