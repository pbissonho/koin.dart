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
import 'package:kt_dart/kt.dart';

import '../error/exceptions.dart';

import '../koin_dart.dart';
import '../module.dart';
import '../qualifier.dart';
import '../scope/scope.dart';
import '../scope/scope_definition.dart';

///
/// Scope Registry
/// create/find scopes for Koin
///
// @author Arnaud Giuliani
///
class ScopeRegistry {
  final Koin koin;
  KtHashMap<String, ScopeDefinition> scopeDefinitions =
      KtHashMap<String, ScopeDefinition>.empty();
  KtHashMap<String, Scope> scopes = KtHashMap<String, Scope>.empty();

//  ScopeDefinition _rootScopeDefinition;
  Scope _rootScope;
  Scope get rootScope => _rootScope;

  int size() {
    var sum = scopeDefinitions.values
        .map<int>((definition) => definition.size())
        .sum();

    return sum;
  }

  ScopeRegistry(this.koin);

  void loadModules(Iterable<Module> modules) {
    for (var module in modules) {
      if (!module.isLoaded) {
        loadModule(module);
        module.isLoaded = true;
      } else {
        koin.logger.error("module '$module' already loaded!");
      }
    }
  }

  void loadModule(Module module) {
    declareScope(module.rootScope);
    declareScopes(module.otherScopes);
  }

  void declareScopes(List<ScopeDefinition> list) {
    list.forEach(declareScope);
  }

  void declareScope(ScopeDefinition scopeDefinition) {
    declareDefinitions(scopeDefinition);
    declareInstances(scopeDefinition);
  }

  void declareInstances(ScopeDefinition scopeDefinition) {
    scopes.values
        .filter((it) => it.scopeDefinition == scopeDefinition)
        .forEach((it) => it.loadDefinitions(scopeDefinition));
  }

  void declareDefinitions(ScopeDefinition definition) {
    if (scopeDefinitions.containsKey(definition.qualifier.value)) {
      mergeDefinitions(definition);
    } else {
      scopeDefinitions[definition.qualifier.value] = definition.copy();
    }
  }

  void mergeDefinitions(ScopeDefinition definition) {
    var existing = scopeDefinitions[definition.qualifier.value];

    if (existing == null) {
      throw IllegalStateException(
          "Scope definition '$definition' not found in $scopeDefinitions");
    }

    definition.definitions.forEach((it) {
      existing.save(it);
    });
  }

  void createRootScopeDefinition() {
    var scopeDefinition = ScopeDefinition.rootDefinition();
    scopeDefinitions[ScopeDefinition.rootScopeQualifier.value] =
        scopeDefinition;
    // _rootScopeDefinition = scopeDefinition;
  }

  void createRootScope() {
    _rootScope ??= createScope(
        ScopeDefinition.rootScopeId, ScopeDefinition.rootScopeQualifier, null);
  }

  Scope getScopeOrNull(String scopeId) {
    return scopes[scopeId];
  }

  Scope createScope(String scopeId, Qualifier qualifier, dynamic source) {
    if (scopes.containsKey(scopeId)) {
      throw ScopeAlreadyCreatedException(
          "Scope with id '$scopeId' is already created");
    }

    var scopeDefinition = scopeDefinitions[qualifier.value];

    if (scopeDefinition != null) {
      var createdScope =
          createScopeWithDefinition(scopeId, scopeDefinition, source);
      scopes[scopeId] = createdScope;
      return createdScope;
    } else {
      throw NoScopeDefFoundException(
          "No Scope Definition found for qualifer '${qualifier.value}'");
    }
  }

  Scope createScopeWithDefinition(
      String scopeId, ScopeDefinition scopeDefinition, dynamic source) {
    var scope = Scope(
        id: scopeId,
        scopeDefinition: scopeDefinition,
        koin: koin,
        source: source);

    KtList<Scope> links;
    if (_rootScope == null) {
      links = emptyList();
    } else {
      links = listOf(_rootScope);
    }
    scope.create(links);
    return scope;
  }

  void deleteScopeByID(String scopeId) {
    scopes.remove(scopeId);
  }

  void deleteScope(Scope scope) {
    scopes.remove(scope.id);
  }

  void close() {
    clearScopes();
    scopes.clear();
    scopeDefinitions.clear();
    //  _rootScopeDefinition = null;
    _rootScope = null;
  }

  void clearScopes() {
    scopes.values.forEach((scope) {
      scope.clear();
    });
  }

  void unloadModules(Iterable<Module> modules) {
    modules.forEach(unloadModule);
  }

  void unloadModule(Module module) {
    var scopeDefinitions = List<ScopeDefinition>.from(module.otherScopes)
      ..add(module.rootScope);
    scopeDefinitions.forEach(unloadDefinitions);
    module.isLoaded = false;
  }

  void unloadDefinitions(ScopeDefinition scopeDefinition) {
    unloadInstances(scopeDefinition);
    scopeDefinitions.values
        .firstOrNull((it) => it == scopeDefinition)
        ?.unloadDefinitions(scopeDefinition);
  }

  void unloadInstances(ScopeDefinition scopeDefinition) {
    scopes.values
        .filter((it) => it.scopeDefinition == scopeDefinition)
        .forEach((it) {
      it.dropInstances(scopeDefinition);
    });
  }
}
