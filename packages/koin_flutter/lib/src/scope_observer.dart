import 'package:flutter/widgets.dart';
import 'package:koin/internals.dart';

// ignore: avoid_classes_with_only_static_members
class FlutterKoinScopeObserver {
  static ScopeWidgetObersever scopeWidgetObserver = ScopeWidgetObersever();
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

class ScopeWidgetContext {
  ScopeWidgetContext(
    this.widgetScopeSource,
    this.scope,
  );

  final Widget widgetScopeSource;
  Scope scope;
}
