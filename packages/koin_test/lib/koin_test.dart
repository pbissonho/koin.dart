/*
 * Copyright 2019 the original author or authors.
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

library koin_test;

export 'src/check/check_modules.dart';
export 'src/check/check_module_dsl.dart';
export 'src/module_test.dart';
export 'src/mock/declare_mock.dart';

import 'package:koin/koin.dart';
import 'package:test/test.dart';

import 'package:koin/src/core/context/koin_context_handler.dart';

/// Koin Test tools
/// @author Pedro Bissonho
///

/// Configures the testing environment to automatically start and close Koin for each test.
///
/// Register a setUp function that starts koin before tests and register a tearDown
/// function that close Koin afters tests.
///
/// The [startKoin] function will be called before each test is run and [stopKoin]
/// function will be called after each test is run.

void koinTest() {
  koinSetUp();
  koinTearDown();
}

/// Register a setUp function that starts koin before tests.
///
/// The [startKoin] function will be called before each test is run.
///
///
void koinSetUp() {
  setUp(() {
    startKoin((app) {});
  });
}

/// Register a tearDown function that close Koin afters tests.
///
/// [stopKoin()] function will be called after each test is run.
void koinTearDown() {
  tearDown(() {
    stopKoin();
  });
}

///
/// Declare a module to be loaded in the global context of koin
///
void declareModule(Function(Module module) moduleDeclaration) {
  var module = Module(false, true);
  moduleDeclaration(module);
  KoinContextHandler.get().loadModule(module);
}

///
/// Declare a instance to be loaded in the global context of koin
///
T declare<T>(T instance, [Qualifier qualifier]) {
  var koin = KoinContextHandler.get();
  koin.declare(instance, qualifier: qualifier, override: true);
  return get(qualifier);
}

///
/// Lazy inject an instance from Koin in the test environment.
///
Lazy<T> inject<T>([Qualifier qualifier, DefinitionParameters parameters]) {
  return KoinContextHandler.get().inject<T>(qualifier, parameters);
}

///
/// Get an instance from Koin in the test environment.
///
T get<T>([Qualifier qualifier, DefinitionParameters parameters]) {
  return KoinContextHandler.get().get<T>(qualifier, parameters);
}
