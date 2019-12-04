/*
 * Copyright 2019-2020 the original author or authors.
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

import 'package:flutter/widgets.dart';
import 'package:koin/koin.dart';

///
/// Provide an scope for given State from a StatefulWidget
///
/// @author Pedro Bissonho
///
mixin ScopeComponent<St extends StatefulWidget> on State<St> {
  Scope _currentScope;

  @override
  void initState() {
    createScope(getScopeId(), getScopeName());
    super.initState();
  }

  @override
  void dispose() {
    getKoin().deleteScope(getScopeId());
    super.dispose();
  }

  Qualifier getScopeName() => TypeQualifier(this.runtimeType);

  String getScopeId() =>
      "${this.widget.runtimeType}@${getScopeName().toString()}";

  Scope getOrCreateCurrentScope() {
    if (_currentScope != null) return _currentScope;

    var scopeId = getScopeId();
    var scope = getKoin().getOrCreateScope(scopeId, getScopeName());

    return scope;
  }

  Scope createScope(String scopeId, Qualifier qualifier) {
    var scope = getKoin().createScope(scopeId, qualifier);
    _currentScope = scope;
    return scope;
  }

  ///
  /// Get Koin context
  ///
  Koin getKoin() {
    return GlobalContext.instance.get().koin;
  }

  ///
  /// inject lazily given dependency for StatefulWidget State
  /// @param qualifier - bean qualifier / optional
  /// @param parameters - injection parameters
  ///
  Lazy<T> inject<T>([Qualifier qualifier, DefinitionParameters parameters]) {
    return Lazy<T>(getKoin().rootScope, qualifier, parameters);
    //return //= lazy { get<T>(qualifier, parameters) };
  }

  ///
  /// get given dependency for StatefulWidget State
  /// @param name - bean name
  /// @param scope
  /// @param parameters - injection parameters
  ///
  T get<T>([Qualifier qualifier, DefinitionParameters parameters]) {
    var scope = getOrCreateCurrentScope();
    return scope.get<T>(qualifier, parameters);
  }

  ///
  /// get given dependency for Flutter Widget, from primary and secondary types
  /// @param parameters - injection parameters
  ///
  S bind<S, P>(DefinitionParameters parameters) {
    return getKoin().bind<S, P>(parameters);
  }

  ///
  /// Get current Koin scope, bound to current lifecycle
  ///
  Scope get currentScope => getOrCreateCurrentScope();
}
