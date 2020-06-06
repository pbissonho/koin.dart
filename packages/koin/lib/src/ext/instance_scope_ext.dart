import '../core/context/koin_context_handler.dart';
import '../core/koin_dart.dart';
import '../core/qualifier.dart';
import '../core/scope/scope.dart';

extension ScopeExt<T> on T {
  String get scopeId => '${toString()}@ $hashCode';

  Qualifier get scopeName => TypeQualifier(T);

  Scope get scope => getOrCreateScope();

  Scope getOrCreateScope([Koin koin]) {
    koin ??= KoinContextHandler.get();
    var currentScope = getScopeOrNull(koin);

    if (currentScope == null) {
      return createScope(koin);
    }

    return currentScope;
  }

  Scope getScopeOrNull([Koin koin]) {
    koin ??= KoinContextHandler.get();
    return koin.getScopeOrNull((scopeId));
  }

  Scope createScope([Koin koin]) {
    koin ??= KoinContextHandler.get();
    return koin.createScope(scopeId, scopeName, this);
  }
}
