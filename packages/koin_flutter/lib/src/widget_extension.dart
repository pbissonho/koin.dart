import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:koin/koin.dart';
import 'package:koin/internals.dart';

import 'scope_observer.dart';

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
  /// And your module must be started in so that it is possible
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
  T get<T>([Qualifier qualifier]) {
    return getKoin().get<T>(qualifier);
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
  T getWithParam<T, P>(P param, {Qualifier qualifier}) {
    return getKoin().getWithParam<T, P>(param, qualifier: qualifier);
  }

  /// Returns a Lazy object that provides the instance for [T].
  ///
  /// The `instance ` resolved is is created only when `value` by `Lazy` being
  /// called for the first time.
  Lazy<T> inject<T>([Qualifier qualifier]) {
    return getKoin().inject<T>(qualifier);
  }

  /// Lazy inject instance from Koin
  /// Use when it is necessary to pass [parameters] to the instance.
  Lazy<T> injectWithParam<T, P>(P param, {Qualifier qualifier}) {
    return getKoin().injectWithParam<T, P>(param, qualifier: qualifier);
  }

  /// Get instance instance from Koin by Primary Type [P], as secondary type [S]
  S bind<S, P>([Qualifier qualifier]) {
    return getKoin().bind<S, P>();
  }

  /// Get instance instance from Koin by Primary Type [P], as secondary type [S]
  S bindWithParam<S, T, P>(P param, {Qualifier qualifier}) {
    return getKoin().bindWithParam<S, T, P>(param);
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
    FlutterKoinObserver.scopeRouterObserver
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
      FlutterKoinObserver.scopeRouterObserver.onCloseScope(_scope.id);
    }
  }
}

/// Class that propagate the 'Scope' down the tree.
///
/// Example of use:
/// ```
/// class MyScopedClass {
///   int get state => 10;
/// }
///
/// // Define a koin module with a scope for `ScopePage`.
/// // Here, the `ScopePage` scope is being defined, which contains a definition
/// // for `MyScopedClass`.
/// final simpleModule = Module()
///   ..scopeOne<MyScopedClass, ScopePage>((_) => MyScopedClass());
///
/// class ScopePage extends StatefulWidget {
///   @override
///   _ScopePageState createState() => _ScopePageState();
/// }
///
/// class _ScopePageState extends State<ScopePage> with ScopeStateMixin {
///   @override
///   Widget build(BuildContext context) {
///    final counterScoped = currentScope.get<MyScopedClass>();
///     return Scaffold(
///       appBar: AppBar(
///         actions: <Widget>[
///           IconButton(
///             icon: Text("ScopeProvider", overflow: TextOverflow.clip),
///             onPressed: () {
///               // Use ScopeProvider to propagate the scope to the widget tree.
///               // That allow to pass the current scope to another route.
///               Navigator.push(context, MaterialPageRoute(builder: (c) {
///                 return ScopeProvider(
///                     scope: currentScope, child: UseScopePage());
///               }));
///             },
///           ),
///         ],
///       ),
///       body: Center(
///         child: Text(counterScoped.state.toString()),
///       ),
///     );
///   }
/// }
///
/// //The second page that uses the scope of the widget above.
/// class UseScopePage extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     final counterScoped = context.scope.get<MyScopedClass>();
///     return Scaffold(
///       body: Center(
///         child: Text(counterScoped.state.toString()),
///       ),
///     );
///   }
/// }
/// ```
/// For more information see `InheritedWidget`.
///
class ScopeProvider extends InheritedWidget {
  const ScopeProvider({
    Key key,
    @required this.scope,
    @required Widget child,
  })  : assert(scope != null),
        assert(child != null),
        super(key: key, child: child);

  final Scope scope;

  static ScopeProvider of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ScopeProvider>();

    if (scope == null) {
      throw ScopeNotFoundException(
          '''The scope was not found.The current context does not have a scope.
          See the ScopeProvider information to propagate the scope to the widget tree.''');
    }

    return scope;
  }

  @override
  bool updateShouldNotify(ScopeProvider old) => scope != old.scope;
}

/// Extension that allows to retrieve a [Scope] from the current context.
/// Equivalent to `ScopeProvider.of(context.scope`.
extension ScopeContextExtension on BuildContext {
  Scope get scope {
    return ScopeProvider.of(this).scope;
  }
}

/// Exception that should be thrown when a scope is not found.
/// This occurs when 'context.scope' is used in a context that has not been
/// scoped.
class ScopeNotFoundException implements Exception {
  ScopeNotFoundException(this.msg);

  final String msg;

  @override
  String toString() {
    return '$runtimeType: $msg';
  }
}
