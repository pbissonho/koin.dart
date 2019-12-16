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

import 'package:koin/src/core/measure.dart';

import 'core/logger.dart';
import 'core/module.dart';
import 'koin_dart.dart';

//
/// Koin Application
/// Help prepare resources for Koin context
// @author - Arnaud Giuliani
//
// Ported to Dart from Kotlin by:
// @author - Pedro Bissonho
//
class KoinApplication {
  Koin koin = Koin();
  static Logger logger = PrintLogger(Level.debug);

  void loadDefaults() {
    koin.scopeRegistry.loadDefaultScopes(koin);
  }

  ///
  /// Load definitions from module
  /// @param module
  ///
  KoinApplication module(Module module) {
    return modules([module]);
  }

  ///
  /// Load definitions from modules
  /// @param modules
  ///
  KoinApplication modules(List<Module> modules) {
    if (logger.isAt(Level.info)) {
      var duration = Measure.measureDurationOnly(() {
        _loadModulesAndScopes(modules);
      });

      var count =
          0; // koin.rootScope.beanRegistry.getAllDefinitions().size + koin.scopeRegistry.getScopeSets().map { it.definitions.size }.sum();
      logger.info("total $count registered definitions");
      logger.info("load modules in $duration ms");
    } else {
      _loadModulesAndScopes(modules);
    }
    return this;
  }

  void _loadModulesAndScopes(Iterable<Module> modules) {
    koin.rootScope.beanRegistry.loadModules(modules);
    koin.scopeRegistry.loadScopes(modules);
  }

  ///
  /// Load properties from Map
  /// @param values
  ///
  KoinApplication properties(Map<String, dynamic> values) {
    // koin.propertyRegistry.saveProperties(values)
    return this;
  }

  ///
  /// Load properties from file
  /// @param fileName
  ///
  KoinApplication fileProperties({String fileName = "/koin.properties"}) {
    // koin.propertyRegistry.loadPropertiesFromFile(fileName);
    return this;
  }

  ///
  /// Load properties from environment
  ///
  KoinApplication environmentProperties() {
    //  koin.propertyRegistry.loadEnvironmentProperties()
    return this;
  }

  ///
  /// Set Koin Logger
  /// @param logger - logger
  ///
  KoinApplication setLogger(Logger logger) {
    KoinApplication.logger = logger;
    return this;
  }

  ///
  /// Set Koin to use [PrintLogger], by default at [Level.INFO]
  ///
  KoinApplication printLogger() {
    return this.setLogger(PrintLogger(Level.debug));
  }

  ///
  /// Create Single instances Definitions marked as createdAtStart
  ///
  KoinApplication createEagerInstances() {
    if (logger.isAt(Level.debug)) {
      var duration = Measure.measureDurationOnly(() {
        koin.createEagerInstances();
      });

      logger.debug("instances started in $duration ms");
    } else {
      koin.createEagerInstances();
    }
    return this;
  }

  ///
  /// Close all resources from Koin & remove Standalone Koin instance
  ///
  void close() {
    koin.close();
    if (logger.isAt(Level.info)) {
      logger.info("stopped");
    }
  }

  KoinApplication unloadModules(List<Module> modules) {
    koin.rootScope.beanRegistry.unloadModules(modules);
    koin.scopeRegistry.unloadScopedDefinitions(modules);

    return this;
  }

  ///
  /// Create a new instance of KoinApplication
  ///
  static KoinApplication create() {
    var app = KoinApplication();
    app.loadDefaults();
    return app;
  }
}
