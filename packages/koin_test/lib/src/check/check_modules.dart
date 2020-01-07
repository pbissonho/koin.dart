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

///
/// Check all definition's dependencies.
///
/// Start all modules and check if definitions can run.
///

void checkModules(List<Module> modules, CheckParameters checkParameters) {
  KoinApplication app = KoinApplication.create();
  app.modules(modules);
  app.createEagerInstances();
  checkKoinModules(checkParameters, app.koin);
}

///
/// Check all definition's dependencies.
///
/// Start the module and check if definitions can run.
///

void checkModule(Module module, CheckParameters checkParameters) {
  KoinApplication app = KoinApplication.create();
  app.module(module);
  app.createEagerInstances();
  checkKoinModules(checkParameters, app.koin);
}

///Check all definition's dependencies.
///
///Start all modules and check if definitions can run
///
void checkKoinModules(CheckParameters parametersDefinition, Koin koin) {
  checkMainDefinitions(parametersDefinition.creators, koin);
  checkScopedDefinitions(parametersDefinition.creators, koin);
  koin.close();
}

void checkScopedDefinitions(
    Map<CheckedComponent, DefinitionParameters> allParameters, Koin koin) {
  var scopeRegistry = koin.scopeRegistry;

  scopeRegistry.getScopeSets().forEach((value) {
    var scope = koin.createScope(value.qualifier.toString(), value.qualifier);
    value.definitions.forEach((definition) {
      var parameters = allParameters[
          CheckedComponent(definition.qualifier, definition.primaryType)];
      scope.getWithType(
          definition.primaryType, definition.qualifier, parameters);
    });
  });
}

void checkMainDefinitions(
    Map<CheckedComponent, DefinitionParameters> allParameters, Koin koin) {
  koin.rootScope.beanRegistry.getAllDefinitions().forEach((definition) {
    var parameters = allParameters[
        CheckedComponent(definition.qualifier, definition.primaryType)];

    if (parameters == null) {
      parameters = parametersOf([]);
    }

    koin.getWithType(definition.primaryType, definition.qualifier, parameters);
  });
}
