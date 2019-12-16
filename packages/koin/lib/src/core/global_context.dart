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

import 'package:koin/src/error/error.dart';
import 'package:koin/src/error/exceptions.dart';
import '../koin_application.dart';
import 'module.dart';

//
// Global context - current Koin Application available globally
//
// Support to help inject automatically instances once KoinApp has been started

// Ported to Dart from Kotlin by:
// @author - Pedro Bissonho
//
class GlobalContext {
  KoinApplication app;

  static final GlobalContext _instance = GlobalContext._internal();
  static GlobalContext get instance => _instance;

  factory GlobalContext() {
    return _instance;
  }

  GlobalContext._internal();

  ///
  /// StandAlone Koin App instance
  ///
  KoinApplication get() {
    if (app == null) {
      error("KoinApplication has not been started");
    }
    return app;
  }

  ///
  /// StandAlone Koin App instance
  ///
  KoinApplication getOrNull() => app;

  ///
  /// Start a Koin Application as StandAlone
  ///
  void start(KoinApplication koinApplication) {
    if (app != null) {
      throw KoinAppAlreadyStartedException(
          "A Koin Application has already been started");
    }
    app = koinApplication;
  }

  ///
  /// Stop current StandAlone Koin application
  ///
  void stop() {
    app?.close();
    app = null;
  }
}

///
/// Start a Koin Application as StandAlone
///
KoinApplication startKoin([void appDeclaration(KoinApplication koin)]) {
  var koinApplication = KoinApplication.create();
  GlobalContext.instance.start(koinApplication);
  appDeclaration(koinApplication);
  koinApplication.createEagerInstances();
  return koinApplication;
}

///
/// Stop current StandAlone Koin application
///
void stopKoin() => GlobalContext.instance.stop();

///
/// Load a Koin module in global Koin context
///
void loadKoinModule(Module module) {
  GlobalContext.instance.get().modules([module]);
}

///
/// Load Koin a list of modules in global Koin context
///
void loadKoinModules(List<Module> modules) {
  GlobalContext.instance.get().modules(modules);
}

///
/// Unload Koin modules from global Koin context
///
void unloadKoinModule(Module module) {
  GlobalContext.instance.get().unloadModules([module]);
}

///
/// Unload Koin modules from global Koin context
///
void unloadKoinModules(List<Module> modules) {
  GlobalContext.instance.get().unloadModules(modules);
}
