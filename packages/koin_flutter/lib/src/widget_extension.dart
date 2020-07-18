import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:koin/koin.dart';

extension ComponentWidgetExtension<T> on Diagnosticable {
  /// Get the associated Koin instance
  Koin getKoin() => KoinContextHandler.get();

  T get<T>([Qualifier qualifier, DefinitionParameters parameters]) {
    return getKoin().get<T>(qualifier, parameters);
  }

  T getWithParams<T>({Qualifier qualifier, DefinitionParameters parameters}) {
    return getKoin().get<T>(qualifier, parameters);
  }

  /// Lazy inject instance from Koin
  Lazy<T> inject<T>([Qualifier qualifier, DefinitionParameters parameters]) {
    return getKoin().inject<T>(qualifier, parameters);
  }

  /// Lazy inject instance from Koin
  Lazy<T> injectWithParams<T>(
      {Qualifier qualifier, DefinitionParameters parameters}) {
    return getKoin().inject<T>(qualifier, parameters);
  }

  /// Get instance instance from Koin by Primary Type P, as secondary type S
  S bind<S, P>([Qualifier qualifier, DefinitionParameters parameters]) {
    return getKoin().bind<S, P>(parameters);
  }

  /// Get instance instance from Koin by Primary Type P, as secondary type S
  S bindWithParams<S, P>(
      {Qualifier qualifier, DefinitionParameters parameters}) {
    return getKoin().bind<S, P>(parameters);
  }
}

extension StatefulWidgetScopeExtensiont<T extends StatefulWidget> on T {
  String get scopeId => '$runtimeType@$hashCode';

  Qualifier get _scopeName => TypeQualifier(runtimeType);

  Scope get scope => _getOrCreateScope();

  Scope _getOrCreateScope() {
    var koin = KoinContextHandler.get();
    var scopeOrNull = _getScopeOrNull(koin);

    if (scopeOrNull == null) {
      return _createScope(koin);
    }

    return scopeOrNull;
  }

  Scope _getScopeOrNull(Koin koin) {
    return koin.getScopeOrNull((scopeId));
  }

  Scope _createScope(Koin koin) {
    return koin.createScope(scopeId, _scopeName, this);
  }
}

/// Extension that provides the `currentScope` for the `State` class.
/// Instead of using widget.scope.get() use currentScope.get().
extension ScopeWidgetExtension<T extends StatefulWidget> on State<T> {
  /// Return the current scope of the `StatefulWidget` from the `State` class.
  Scope get currentScope {
    return widget.scope;
  }
}

///A mixin that overrides the `dispose` method to call the `currentScope.close()`method of
///the current scope when the [T] is removed from widget tree.
mixin ScopeStateMixin<T extends StatefulWidget> on State<T> {
  Scope _scope;

  /// Return the current scope of the [T].
  Scope get currentScope {
    if (_scope != null) return _scope;
    _scope = widget.scope;
    return _scope;
  }

  Scope _getScopeOrNull() {
    return KoinContextHandler.get().getScopeOrNull((widget.scopeId));
  }

  @override
  void dispose() {
    super.dispose();
    if (_scope == null) {
      final widgetScope = _getScopeOrNull();
      if (widgetScope != null && !widgetScope.closed) {
        widgetScope.close();
      }
    } else if (!_scope.closed) {
      _scope.close();
    }
  }
}
