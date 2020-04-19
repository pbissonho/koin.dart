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

import 'package:koin/src/core/error/exceptions.dart';
import 'package:kt_dart/kt.dart';

import '../../koin_application.dart';
import '../../koin_dart.dart';
import '../logger.dart';
import '../module.dart';
import '../qualifier.dart';
import '../scope.dart';
import '../scope_set.dart';

///
/// Scope Registry
/// create/find scopes for Koin
///
// @author Arnaud Giuliani
///
class ScopeRegistry {
  final definitions = KtHashMap<String, ScopeDefinition>.empty();
  final _instances = KtHashMap<String, Scope>.empty();

  ///
  /// return all ScopeSet
  ///
  KtMutableCollection<ScopeDefinition> getScopeSets() => definitions.values;

  void loadScopes(Iterable<Module> modules) {
    modules.forEach((it) {
      declareScopes(it);
    });
  }

  void unloadScopedDefinitions(Iterable<Module> modules) {
    modules.forEach((it) {
      unloadScopes(it);
    });
  }

  void unloadScopes(Module module) {
    module.scopes.forEach((scope) {
      unloadDefinition(scope);
    });
  }

  void loadDefaultScopes(Koin koin) {
    _saveInstance(koin.rootScope);
  }

  void declareScopes(Module module) {
    module.scopes.forEach((it) {
      saveDefinition(it);
    });
  }

  void unloadDefinition(ScopeSet scopeSet) {
    var key = scopeSet.qualifier.toString();

    var scopeDefinition = definitions[key];

    if (KoinApplication.logger.isAt(Level.debug)) {
      KoinApplication.logger.info(
          "unbind scoped definitions: ${scopeSet.definitions} from '${scopeSet.qualifier}'");
    }
    closeRelatedScopes(scopeDefinition);
    scopeDefinition.definitions.removeAll(scopeSet.definitions);
  }

  void closeRelatedScopes(ScopeDefinition originalSet) {
    _instances.values.forEach((scope) {
      if (scope.scopeDefinition == originalSet) {
        scope.close();
      }
    });
  }

  void saveDefinition(ScopeSet scopeSet) {
    var foundScopeSet = definitions[scopeSet.qualifier.toString()];
    if (foundScopeSet == null) {
      definitions[scopeSet.qualifier.toString()] = scopeSet.createDefinition();
    } else {
      foundScopeSet.definitions.addAll(scopeSet.definitions);
    }
  }

  ScopeDefinition getScopeDefinition(String scopeName) =>
      definitions[scopeName];

  ///
  /// Create a scope instance for given scope
  ///
  Scope createScopeInstance(Koin koin, String id, Qualifier scopeName) {
    var definition = definitions[scopeName.toString()];

    if (definition == null) {
      throw NoScopeDefinitionFoundException(
          "No scope definition found for scopeName '$scopeName'");
    }
    var instance = Scope(id: id, koin: koin, isRoot: false);
    instance.scopeDefinition = definition;
    instance.declareDefinitionsFromScopeSet();
    registerScopeInstance(instance);
    return instance;
  }

  void registerScopeInstance(Scope instance) {
    if (_instances[instance.id] != null) {
      throw ScopeAlreadyCreatedException(
          "A scope with id '${instance.id}' already exists. Reuse or close it.");
    }
    _saveInstance(instance);
  }

  Scope getScopeInstance(String id) {
    var instance = _instances[id];
    if (instance == null) {
      throw ScopeNotCreatedException(
          "ScopeInstance with id '$id' not found. Create a scope instance with id '$id'");
    }
    return instance;
  }

  void _saveInstance(Scope instance) {
    _instances[instance.id] = instance;
  }

  Scope getScopeInstanceOrNull(String id) {
    return _instances[id];
  }

  void deleteScopeInstance(String id) {
    _instances.remove(id);
  }

  void close() {
    _instances.values.forEach((it) => it.close());
    definitions.clear();
    _instances.clear();
  }
}
