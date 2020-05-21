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

import 'package:koin/koin.dart';
import 'check_module_dsl.dart';
import 'package:koin/src/core/scope/scope_definition.dart';
import 'package:koin/src/dsl/koin_application_dsl.dart';

extension KoinApplicationExt on KoinApplication {
  void checkModules(CheckParameters checkParameters) {
    koin.checkModules(checkParameters);
  }
}

void checkModules(Level level, CheckParameters checkParameters,
    Function(KoinApplication app) appDeclaration) {
  koinApplication(appDeclaration)
    ..logger(PrintLogger(level))
    ..checkModules(checkParameters);
}

extension KoinExt on Koin {
  ///
  /// Check all definition's dependencies - start all modules and check if definitions can run
  ///
  
  void checkModules(CheckParameters checkParameters) {
    logger.info('[Check] checking current modules ...');

    var allParameters = makeParameters(checkParameters);
    checkScopedDefinitions(allParameters);

    close();

    logger.info('[Check] modules checked');
  }

  Map<CheckedComponent, DefinitionParameters> makeParameters(
      CheckParameters checkParameters) {
    var bindings = ParametersBinding();
    bindings.koin = this;

    bindings.creators = checkParameters.creators;

    return bindings.creators;
  }

  void checkScopedDefinitions(
      Map<CheckedComponent, DefinitionParameters> allParameters) {
    scopeRegistry.scopeDefinitions.values.forEach((scopeDefinition) {
      runScope(scopeDefinition, allParameters);
    });
  }

  void runScope(ScopeDefinition scopeDefinition,
      Map<CheckedComponent, DefinitionParameters> allParameters) {
    var scope = getOrCreateScope(
        scopeDefinition.qualifier.value, scopeDefinition.qualifier);

    scope.scopeDefinition.definitions.forEach((it) {
      runDefinition(allParameters, it, scope);
    });
  }
}

void runDefinition(Map<CheckedComponent, DefinitionParameters> allParameters,
    BeanDefinition it, Scope scope) {
  var parameters =
      allParameters[CheckedComponent(it.qualifier, it.primaryType)];
  parameters ??= parametersOf([]);

  scope.getWithType(it.primaryType, it.qualifier, parameters);
}
