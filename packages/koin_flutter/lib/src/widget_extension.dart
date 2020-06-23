import 'package:flutter/foundation.dart';
import 'package:koin/koin.dart';

extension KoinStatefulExtension<T> on Diagnosticable {
  ///
  /// Get the associated Koin instance
  ///
  Koin getKoin() => KoinContextHandler.get();

  T get<T>([Qualifier qualifier, DefinitionParameters parameters]) {
    return getKoin().get<T>(qualifier, parameters);
  }

  ///
  /// Lazy inject instance from Koin
  /// @param qualifier
  /// @param parameters
  ///
  Lazy<T> inject<T>([Qualifier qualifier, DefinitionParameters parameters]) {
    return getKoin().inject<T>(qualifier, parameters);
  }

  ///
  /// Get instance instance from Koin by Primary Type P, as secondary type S
  /// @param parameters
  ///
  S bind<S, P>([Qualifier qualifier, DefinitionParameters parameters]) {
    return getKoin().bind<S, P>(parameters);
  }
}

extension ScopeWidgetExtensiont<T extends Diagnosticable> on T {
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
