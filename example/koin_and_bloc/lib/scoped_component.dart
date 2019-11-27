import 'package:flutter/material.dart';
import 'package:koin/koin.dart';
import 'package:koin/src/koin_dart.dart';
import 'package:koin/src/core/definition_parameters.dart';

mixin ScopedComponent<St extends StatefulWidget> on State<St>
    implements KoinComponent {
  Qualifier _scopeName;
  String id;

  Qualifier get scopeName => _scopeName;

  Scope get currentScope => getScope;

  ///
  /// Get instance instance from Koin
  /// @param qualifier
  /// @param parameters
  ///
  T get<T>(Qualifier qualifier, DefinitionParameters parameters) =>
      getKoin().get(qualifier, parameters);

  ///
  /// Lazy inject instance from Koin
  /// @param qualifier
  /// @param parameters
  ///
  T inject<T>({Qualifier qualifier, List<Object> parameters}) =>
      getKoin().inject(qualifier, parametersOf(parameters));

  ///
  /// Get instance instance from Koin by Primary Type P, as secondary type S
  /// @param parameters
  ///
  S bind<S, P>(Qualifier qualifier, DefinitionParameters parameters) =>
      getKoin().bind<S, P>(parameters);

  Scope get getScope {
    return getKoin().getScope(id);
  }

  @override
  Koin getKoin() {
    return GlobalContext.instance.get().koin;
  }

  @override
  void dispose() {
    getKoin().deleteScope(id);
    super.dispose();
  }

  @override
  void initState() {
    _scopeName = StringQualifier(this.widget.runtimeType.toString());
    id = "${this.widget.hashCode.toString()}@${scopeName.toString()}";
    getKoin().createScope(id, scopeName);
    super.initState();
  }

  void close() {
    getKoin().deleteScope(id);
  }
}
