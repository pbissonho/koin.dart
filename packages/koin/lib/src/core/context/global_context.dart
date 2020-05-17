/*
 * Copyright 2017-2018 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:koin/src/core/error/error.dart';
import 'package:koin/src/core/error/exceptions.dart';

import '../koin_application.dart';
import '../koin_dart.dart';
import 'koin_context.dart';

//
// Global context - current Koin Application available globally
//
// Support to help inject automatically instances once KoinApp has been started

// Ported to Dart from Kotlin by:
// @author - Pedro Bissonho
//
class GlobalContext implements KoinContext {
  Koin _koin;

  ///
  /// StandAlone Koin App instance
  ///
  @override
  Koin get() {
    if (_koin == null) {
      throw IllegalStateException('KoinApplication has not been started');
    }
    return _koin;
  }

  ///
  /// StandAlone Koin App instance
  ///
  @override
  Koin getOrNull() => _koin;

  ///
  /// Start a Koin Application as StandAlone
  ///
  @override
  void setup(koinApplication) {
    if (_koin != null) {
      throw KoinAppAlreadyStartedException(
          'A Koin Application has already been started');
    }
    _koin = koinApplication.koin;
  }

  ///
  /// Stop current StandAlone Koin application
  ///
  void stop() {
    _koin?.close();
    _koin = null;
  }
}
