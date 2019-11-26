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

import 'package:koin/src/core/global_context.dart';
import 'package:koin/src/core/qualifier.dart';
import 'package:koin/src/core/scope.dart';
import '../koin_dart.dart';
import 'definition_parameters.dart';

///
/// KoinComponent interface marker to bring Koin extensions features
///
/// @author Arnaud Giuliani
///

/*
abstract class KoinComponent {
  
}*/

mixin KoinComponent {
  Scope scope;

  ///
  /// Get instance instance from Koin
  /// @param qualifier
  /// @param parameters
  ///
  T get<T>(Qualifier qualifier, DefinitionParameters parameters) =>
      getKoin().get(qualifier, parameters);

  ///
  /// Lazy inject instance from Koin
  /// @param qualifier
  /// @param parameters
  ///
  T inject<T>() => getKoin().inject(null, null);

  ///
  /// Get instance instance from Koin by Primary Type P, as secondary type S
  /// @param parameters
  ///
  S bind<S, P>(Qualifier qualifier, DefinitionParameters parameters) =>
      getKoin().bind<S, P>(parameters);

  ///
  /// Get the associated Koin instance
  ///
  Koin getKoin() => GlobalContext.instance.get().koin;

  Scope get currentScope => scope;

  void init() {
    var name = this.runtimeType.toString();
    var id = "$this.hashCode.toString()$name";
    scope = getKoin().getOrCreateScope(id, named(name));
  }

  void dispose() {
    getKoin().deleteScope(this.hashCode.toString());
  }
}

/*
class Lazy<T> {
  T _cache;
  Lazy();

  T get inject => call();

  T call() {
    if (_cache != null) {
      return _cache;
    }
    _cache = getKoin().get<T>(null, null);

    return _cache;
  }

  Koin getKoin() => GlobalContext.instance.get().koin;
}*/
