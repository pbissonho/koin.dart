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

import 'context/context_handler.dart';
import 'definition_parameter.dart';
import 'qualifier.dart';
import 'koin_dart.dart';
import 'lazy.dart';
import 'scope/scope.dart';

///
/// KoinComponentMixin interface marker to bring Koin extensions features
///
/// @author Arnaud Giuliani
///

mixin KoinComponentMixin {
  ///
  /// Get the associated Koin instance
  ///
  Koin getKoin() => KoinContextHandler.get();

  T get<T>([Qualifier qualifier]) {
    return getKoin().get<T>(qualifier);
  }

  T getWithParam<T, P>(P param, {Qualifier qualifier}) {
    return getKoin().getWithParam<T, P>(param);
  }

  ///
  /// Lazy inject instance from Koin
  /// @param qualifier
  /// @param parameters
  ///
  Lazy<T> inject<T>([Qualifier qualifier]) {
    return getKoin().inject<T>(qualifier);
  }

  ///
  /// Lazy inject instance from Koin
  ///
  Lazy<T> injectWithParam<T, P>(P param, {Qualifier qualifier}) {
    return getKoin().injectWithParam<T, P>(param, qualifier: qualifier);
  }

  ///
  /// Get instance instance from Koin by Primary Type P, as secondary type S
  /// @param parameters
  ///
  S bind<S, P>([Qualifier qualifier]) {
    return getKoin().bind<S, P>();
  }

  ///
  /// Get instance instance from Koin by Primary Type K, as secondary type S
  /// @param parameters
  ///
  /// TODO
  S bindWithParam<S, K, P>(
      {Qualifier qualifier, DefinitionParameter definitionParameter}) {
    return getKoin().bind<S, P>(qualifier);
  }
}

mixin ScopedComponentMixin {
  ///
  /// Get the associated Koin instance
  ///
  Scope componentScope();

  T get<T>([Qualifier qualifier]) {
    return componentScope().get<T>(qualifier);
  }

  T getWithParam<T, P>(P param, {Qualifier qualifier}) {
    return componentScope().getWithParam<T, P>(param);
  }

  ///
  /// Lazy inject instance from Koin
  /// @param qualifier
  /// @param parameters
  ///
  Lazy<T> inject<T>([Qualifier qualifier]) {
    return componentScope().inject<T>(qualifier);
  }

  ///
  /// Lazy inject instance from Koin
  ///
  Lazy<T> injectWithParam<T, P>(P param, {Qualifier qualifier}) {
    return componentScope().injectWithParam<T, P>(param, qualifier: qualifier);
  }

  ///componentScope
  /// Get instance instance from Koin by Primary Type P, as secondary type S
  /// @param parameters
  ///
  S bind<S, P>([Qualifier qualifier]) {
    return componentScope().bind<S, P>(qualifier);
  }

  ///
  /// Get instance instance from Koin by Primary Type K, as secondary type S
  /// @param parameters
  ///
  /// TODO
  S bindWithParam<S, K, P>(
      {Qualifier qualifier, DefinitionParameter definitionParameter}) {
    return componentScope().bind<S, P>();
  }
}

///
/// KoinComponent interface marker to bring Koin extensions features
///
class KoinComponent with KoinComponentMixin {}
