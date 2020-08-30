import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:koin/internal.dart';
import 'package:koin/koin.dart';

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
