import '../internal/exceptions.dart';
import '../koin_application.dart';
import '../koin_dart.dart';

/*
 * Copyright 2017-2020 the original author or authors.
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

///
/// Component thath hold the Koin instance
///
abstract class KoinContext {
  ////
  ///Retrieve current KoinContext
  ///
  Koin get();

  ///
  /// Retrieve current KoinContext or null
  ///
  Koin? getOrNull();

  ///
  /// sets up a Koin Application
  ///
  void setup(KoinApplication koinApplication);

  ///
  ///Stop current KoinContext
  ///
  void stop();
}

//Ported to Dart from Kotlin by:
//@author - Pedro Bissonho

/// Global context - current Koin Application available globally
///
///Support to help inject automatically instances once KoinApp has been started
///
class GlobalContext implements KoinContext {
  Koin? _koin;

  ///
  /// Returns the global instance of the [Koin].
  ///
  /// If koin has not been started with "startKoin" an
  /// IllegalStateException will be thrown.
  ///
  @override
  Koin get() {
    if (_koin == null) {
      throw IllegalStateException('KoinApplication has not been started.');
    }
    return _koin!;
  }

  ///
  /// StandAlone Koin App instance
  ///
  @override
  Koin? getOrNull() => _koin;

  ///
  /// Start a Koin Application as StandAlone
  ///
  @override
  void setup(KoinApplication koinApplication) {
    if (_koin != null) {
      throw KoinAppAlreadyStartedException(
          'A Koin Application has already been started');
    }
    _koin = koinApplication.koin;
  }

  ///
  /// Stop current StandAlone Koin application
  ///
  @override
  void stop() {
    _koin?.close();
    _koin = null;
  }
}
