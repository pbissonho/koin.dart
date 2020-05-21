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
/*
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:koin/koin.dart';
import 'package:koin/src/core/context/koin_context_handler.dart';



///
/// Provide an scope for given State from a StatefulWidget
///
/// @author Pedro Bissonho
///
mixin ScopeComponentMixin<St extends StatefulWidget> on State<St> {
  Scope _currentScope;

  @override
  void initState() {
    _getOrCreateCurrentScope();
    super.initState();
  }

  @override
  void dispose() {
    getKoin().deleteScope(_getScopeId());
    _currentScope = null;
    super.dispose();
  }

  ///
  /// Inject lazily given dependency for State
  ///
  Lazy<T> inject<T>([Qualifier qualifier, DefinitionParameters parameters]) {
    return getKoin().inject<T>(qualifier, parameters);
    //return //= lazy { get<T>(qualifier, parameters) };
  }

  ///
  /// get given dependency for State
  ///
  T get<T>([Qualifier qualifier, DefinitionParameters parameters]) {
    var scope = _getOrCreateCurrentScope();
    return scope.get<T>(qualifier, parameters);
  }

  Qualifier _getScopeName() => named(this.widget.runtimeType.toString());

  String _getScopeId() =>
      "${this.widget.runtimeType}@${_getScopeName().toString()}";

  Scope _getOrCreateCurrentScope() {
    if (_currentScope != null) return _currentScope;

    var scopeId = _getScopeId();
    var scope = getKoin().getOrCreateScope(scopeId, _getScopeName());
    _currentScope = scope;

    return scope;
  }

  ///
  /// Get current Koin scope, bound to current lifecycle
  ///
  Scope get currentScope => _getOrCreateCurrentScope();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Scope>(
      'CurrentScope',
      _currentScope,
      description: "CurrentScope of this widget",
      defaultValue: null,
    ));
  }

  Koin getKoin() {
    return KoinContextHandler.get();
  }
}
*/