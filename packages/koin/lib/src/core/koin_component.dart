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
import 'package:koin/src/core/context/koin_context_handler.dart';
import 'package:koin/src/core/qualifier.dart';
import 'definition_parameters.dart';
import 'koin_dart.dart';
import 'lazy/lazy.dart';

///
/// KoinComponent interface marker to bring Koin extensions features
///
/// @author Arnaud Giuliani
///

abstract class KoinComponent {
  ///
  /// Get the associated Koin instance
  ///
  Koin getKoin() => KoinContextHandler.get();
}

mixin InjectComponent implements KoinComponent {
  @override
  Koin getKoin() => KoinContextHandler.get();

  T get<T>([Qualifier qualifier, DefinitionParameters parameters]) =>
      getKoin().get(qualifier, parameters);

  ///
  /// Lazy inject instance from Koin
  /// @param qualifier
  /// @param parameters
  ///
  Lazy<T> inject<T>([Qualifier qualifier, List<Object> parameters]) {
    if (parameters != null) {
      return getKoin().inject(qualifier, parametersOf(parameters));
    } else {
      return getKoin().inject(qualifier, null);
    }
  }

  ///
  /// Get instance instance from Koin by Primary Type P, as secondary type S
  /// @param parameters
  ///
  S bind<S, P>(Qualifier qualifier, DefinitionParameters parameters) =>
      getKoin().bind<S, P>(parameters);
}
