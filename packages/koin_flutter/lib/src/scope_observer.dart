import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:koin/internals.dart';
import 'package:koin/koin.dart';

class FlutterKoinObserver {
  static final ScopeWidgetObersever scopeRouterObserver =
      ScopeWidgetObersever();
  static final KoinScopeObserver scopeObserver = KoinScopeObserver();
}

class KoinScopeObserver implements ScopeObserver {
  final HashSet<Scope> scopes = HashSet.from([]);

  @override
  void onClose(Scope scope) {
    scopes.remove(scope);
  }

  @override
  void onCreate(Scope scope) {
    scopes.add(scope);
  }
}

class ScopeWidgetObersever {
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
    FlutterKoinObserver.scopeRouterObserver.onCloseScope(scope.id);
    var qualifier = TypeQualifier(widgetScopeSource.runtimeType);
    scope =
        KoinContextHandler.get().createScopeWithQualifier(scope.id, qualifier);
    replace();
  }
}
