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

import '../error/exceptions.dart';
import '../koin_application.dart';
import '../koin_dart.dart';
import 'koin_context.dart';

///
/// Help hold any implementation of KoinContext
///
class KoinContextHandler {
  static KoinContext _context;

  ////
  ///Retrieve current KoinContext
  ///
  static KoinContext getContext() {
    if (_context == null) {
      throw IllegalStateException("""
No Koin Context configured. Please use startKoin or koinApplication DSL. """);
    }
    return _context;
  }

  ////
  ///Retrieve current KoinContext
  ///
  static Koin get() => getContext().get();

  ///
  /// Retrieve current KoinContext or null
  ///
  static Koin getOrNull() => _context?.getOrNull();

  ///
  ///Register new KoinContext
  ///
  /// @throws IllegalStateException if already registered
  ///

  static void register(KoinContext koinContext) {
    if (_context != null) {
      throw IllegalStateException('A KoinContext is already started');
    }
    _context = koinContext;
  }

  ///
  /// Start a Koin Application on current KoinContext
  ///
  static void start(KoinApplication koinApplication) {
    getContext().setup(koinApplication);
  }

  ///
  ///Stop current KoinContext & clear it
  ///
  static void stop() {
    _context?.stop();
    _context = null;
  }
}
