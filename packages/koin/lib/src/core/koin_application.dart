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

import 'measure.dart';
import 'koin_dart.dart';
import 'logger.dart';
import 'module.dart';

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

  void initInter() {
    koin.scopeRegistry.createRootScopeDefinition();
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
    if (koin.logger.isAt(Level.info)) {
      var duration = Measure.measureDurationOnly(() {
        _loadModules(modules);
      });

      var count = koin.scopeRegistry.size();
      koin.logger.info('loaded $count definitions - $duration ms');
    } else {
      _loadModules(modules);
    }

    if (koin.logger.isAt(Level.info)) {
      var duration = Measure.measureDurationOnly(() {
        koin.createRootScope();
      });

      koin.logger.info('create context - $duration ms');
    } else {
      koin.createRootScope();
    }

    return this;
  }

  void _loadModules(List<Module> modules) {
    koin.loadModules(modules);
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
  KoinApplication fileProperties({String fileName = '/koin.properties'}) {
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
  KoinApplication logger(Logger logger) {
    koin.logger = logger;
    return this;
  }

  ///
  /// Set Koin to use [PrintLogger], by default at [Level.INFO]
  ///
  KoinApplication printLogger({Level level = Level.info}) {
    logger(PrintLogger(level));
    return this;
  }

  ///
  /// Create Single instances Definitions marked as createdAtStart
  ///
  KoinApplication createEagerInstances() {
    if (koin.logger.isAt(Level.debug)) {
      var duration = Measure.measureDurationOnly(() {
        koin.createEagerInstances();
      });

      koin.logger.debug('instances started in $duration ms');
    } else {
      koin.createEagerInstances();
    }
    return this;
  }

  void close() {
    koin.close();
  }

  void unloadModules(List<Module> modules) {
    koin.scopeRegistry.unloadModules(modules);
  }

  void unloadModule(Module modules) {
    koin.scopeRegistry.unloadModule(modules);
  }

  static KoinApplication init() {
    var app = KoinApplication();
    app.initInter();
    return app;
  }
}
