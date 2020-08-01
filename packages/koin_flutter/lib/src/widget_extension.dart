import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:koin/koin.dart';

/// Extension to provide `KoinComponent` methods for Flutter Widgets.
extension ComponentWidgetExtension<T> on Diagnosticable {
  /// Get the associated Koin instance
  Koin getKoin() => KoinContextHandler.get();

  ///{@template koinsingle}
  /// Return single definition instance for
  /// Example of use:
  ///
  ///
  /// First, you need to define the definition for
  /// And your module must be started in  so that it is possible
  /// to resolve the instance.
  ///
  /// ```
  /// var blocModule = Module()..single((s) => Bloc());
  ///
  /// ```
  ///
  /// {@endtemplate}

  /// Resolve the instance in a Flutter widget
  /// ```
  /// class Page extends StatelessWidget {
  ///   final bloc = get<CouterBloc>();
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Container(
  ///       child: Text(bloc.state.toString()),
  ///     );
  ///   }
  /// }
  /// ```
  ///
  T get<T>([Qualifier qualifier, DefinitionParameters parameters]) {
    return getKoin().get<T>(qualifier, parameters);
  }

  /// Return single definition instance for [T]
  /// Use when it is necessary to pass [parameters] to the instance.
  ///
  ///
  /// ```
  /// class Page extends StatelessWidget {
  ///  final bloc = getWithParams<CouterBloc>();
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: Text(bloc.state.toString()),
  ///    );
  ///  }
  /// }
  /// 
  /// ```
  ///
  /// {@macro koinsingle}
  ///
  T getWithParams<T>({Qualifier qualifier, DefinitionParameters parameters}) {
    return getKoin().get<T>(qualifier, parameters);
  }

  /// Returns a Lazy object that provides the instance for [T].
  ///
  /// The `instance ` resolved is is created only when `value` by `Lazy` being
  /// called for the first time.
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

  Qualifier get _scopeQualifier => TypeQualifier(runtimeType);

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
    return koin.createScopeWithQualifier(scopeId, _scopeQualifier, this);
  }
}

/// Extension that provides the `currentScope` for the `State` class.
/// Instead of using `widget.scope.get() use currentScope.get().
extension ScopeWidgetExtension<T extends StatefulWidget> on State<T> {
  /// Return the current scope of the `StatefulWidget` from the `State` class.
  Scope get currentScope {
    return widget.scope;
  }

  /// Return the current scope of the `StatefulWidget` from the `State` class.
  Scope get scopeContext => currentScope;
}

/// A mixin that overrides the `dispose` method to call the
/// `currentScope.close()`method of the current scope when the [T]
/// is removed from widget tree.
mixin HotRestartScopeMixin on StatefulWidget {
  Widget get route;
}

/// A mixin that overrides the `dispose` method to call the
/// `currentScope.close()`method of the current scope when the [T]
/// is removed from widget tree.
mixin ScopeStateMixin<T extends StatefulWidget> on State<T> {
  Scope _scope;

  /// Return the current scope of the `StatefulWidget` widget instance.
  ///
  /// `Scope` instance created and related to the `StatefulWidget`
  /// instance in the widget tree.
  Scope get currentScope {
    if (_scope != null && !_scope.closed) return _scope;
    _scope = widget.scope;
    scopeObserver
        .onCreateScope(ScopeWidgetContext(widget, _scope, setState, _replace));
    return _scope;
  }

  Scope get scopeContext => currentScope;

  /// Replace the current `route` with a new one so that
  /// the child states' hot restart.
  void _replace() {
    if (widget is HotRestartScopeMixin) {
      Navigator.replace(context,
          oldRoute: ModalRoute.of(context),
          newRoute: MaterialPageRoute(
              builder: (context) => (widget as HotRestartScopeMixin).route));
    }
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
      scopeObserver.onCloseScope(_scope.id);
    }
  }
}

ScopeWidgetObersever scopeObserver = ScopeWidgetObersever();

class ScopeWidgetObersever {
  static void setObserver(ScopeWidgetObersever observer) {
    scopeObserver = observer;
  }

  Map<String, ScopeWidgetContext> scopeContexts = {};

  void onCreateScope(ScopeWidgetContext scopeWidgetContext) {
    scopeContexts[scopeWidgetContext.scope.id] = scopeWidgetContext;
  }

  void onCloseScope(String id) {
    scopeContexts.removeWhere((key, value) => value.scope.id == id);
  }
}

typedef SetState = void Function(VoidCallback callback);

class ScopeWidgetContext {
  ScopeWidgetContext(
    this.widgetScopeSource,
    this.scope,
    this.setState,
    this.replace,
  );

  final Widget widgetScopeSource;
  Scope scope;
  final SetState setState;
  final Function replace;

  void hotRestartScope() {
    scope.close();
    scopeObserver.onCloseScope(scope.id);
    var qualifier = TypeQualifier(widgetScopeSource.runtimeType);
    scope =
        KoinContextHandler.get().createScopeWithQualifier(scope.id, qualifier);
    replace();
  }
}
