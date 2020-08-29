import '../context/context_handler.dart';
import '../koin_dart.dart';
import '../qualifier.dart';
import '../scope/scope.dart';

extension ScopeExt<T> on T {
  String get scopeId => '$runtimeType@$hashCode';

  Qualifier get scopeName => TypeQualifier(runtimeType);

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
    return koin.createScopeWithQualifier(scopeId, scopeName, this);
  }
}
