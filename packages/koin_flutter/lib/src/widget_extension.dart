import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:koin/koin.dart';

/// Extension to provide `KoinComponent` methods for Flutter Widgets.
extension ComponentWidgetExtension<T> on Diagnosticable {
  /// Get the associated Koin instance
  Koin getKoin() => KoinContextHandler.get();

  /// Get the associated Koin instance
  T get<T>([Qualifier qualifier, DefinitionParameters parameters]) {
    return getKoin().get<T>(qualifier, parameters);
  }

  /// Get the associated Koin instance.
  /// Use when it is necessary to pass [parameters] to the instance.
  T getWithParams<T>({Qualifier qualifier, DefinitionParameters parameters}) {
    return getKoin().get<T>(qualifier, parameters);
  }

  /// Lazy inject instance from Koin
  Lazy<T> inject<T>([Qualifier qualifier, DefinitionParameters parameters]) {
    return getKoin().inject<T>(qualifier, parameters);
  }

  /// Lazy inject instance from Koin
  /// Use when it is necessary to pass [parameters] to the instance.
  Lazy<T> injectWithParams<T>(
      {Qualifier qualifier, DefinitionParameters parameters}) {
    return getKoin().inject<T>(qualifier, parameters);
  }

  /// Get instance instance from Koin by Primary Type [P], as secondary type [S]
  S bind<S, P>([Qualifier qualifier, DefinitionParameters parameters]) {
    return getKoin().bind<S, P>(parameters);
  }

  /// Get instance instance from Koin by Primary Type [P], as secondary type [S]
  S bindWithParams<S, P>(
      {Qualifier qualifier, DefinitionParameters parameters}) {
    return getKoin().bind<S, P>(parameters);
  }
}

/// Extension to provide the Koin scope API for StatefulWidget.
///
/// Allows scope to be created and related to StatefulWidget transparently.
extension StatefulWidgetScopeExtensiont<T extends StatefulWidget> on T {
  /// Id of the current scope related to StatefulWidget [T].
  String get scopeId => '$runtimeType@$hashCode';

  Qualifier get _scopeName => TypeQualifier(runtimeType);

  /// Return the current scope.
  ///
  /// Scope instance created and related to the StatefulWidget
  /// instance in the widget tree.
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
    return koin.createScopeWithQualifier(scopeId, _scopeName, this);
  }
}

/// Extension that provides the `currentScope` for the `State` class.
/// Instead of using `widget.scope.get() use currentScope.get().
extension ScopeWidgetExtension<T extends StatefulWidget> on State<T> {
  /// Return the current scope of the `StatefulWidget` from the `State` class.
  Scope get currentScope {
    return widget.scope;
  }
}

/// A mixin that overrides the `dispose` method to call the
/// `currentScope.close()`method of the current scope when the [T]
/// is removed from widget tree.
mixin ScopeStateMixin<T extends StatefulWidget> on State<T> {
  Scope _scope;

  /// Return the current scope of the 'StatefulWidget' widget instance.
  ///
  /// `Scope` instance created and related to the StatefulWidget
  /// instance in the widget tree.
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
