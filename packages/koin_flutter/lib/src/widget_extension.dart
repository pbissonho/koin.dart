import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:koin/koin.dart';

extension KoinStatefulExtension<T> on Diagnosticable {
  ///
  /// Get the associated Koin instance
  ///
  Koin getKoin() => KoinContextHandler.get();

  T get<T>([Qualifier qualifier, DefinitionParameters parameters]) {
    return getKoin().get<T>(qualifier, parameters);
  }

  T getWithParams<T>({Qualifier qualifier, DefinitionParameters parameters}) {
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
  /// Lazy inject instance from Koin
  Lazy<T> injectWithParams<T>({Qualifier qualifier, DefinitionParameters parameters}) {
    return getKoin().inject<T>(qualifier, parameters);
  }

  ///
  /// Get instance instance from Koin by Primary Type P, as secondary type S
  /// 
  S bind<S, P>([Qualifier qualifier, DefinitionParameters parameters]) {
    return getKoin().bind<S, P>(parameters);
  }

  ///
  /// Get instance instance from Koin by Primary Type P, as secondary type S
  S bindWithParams<S, P>({Qualifier qualifier, DefinitionParameters parameters}) {
    return getKoin().bind<S, P>(parameters);
  }
}

extension ScopeWidgetExtensiont<T extends Diagnosticable> on T {
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
    return koin.createScope(scopeId, scopeName, this);
  }
}

extension ScopeWidgetExtensionX<T extends StatefulWidget> on State<T> {
  Scope get currentScope {
    return widget.scope;
  }
}
