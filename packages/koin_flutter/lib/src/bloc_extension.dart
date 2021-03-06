import 'package:koin/extension.dart';
import 'package:koin/koin.dart';
import 'package:koin/internals.dart';
import 'disposable_extension.dart';

extension BlocModuleExtension on Module {
  ///Pass to use:
  /// ```
  /// var blocModule = Module()..disposable((s) => Bloc());
  /// ```
  /// With the launch of the "koin_bloc" package, this will have been
  /// renamed to avoid confusion.
  ///
  /// This will be removed in the next versions, , then use 'disposable'.
  ///
  ///
  @deprecated
  ProviderDefinition<T> bloc<T extends Disposable>(
    ProviderCreate<T> definition, {
    Qualifier? qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    var beanDefinition = single<T>(definition,
        qualifier: qualifier,
        createdAtStart: createdAtStart,
        override: override);

    beanDefinition.onClose((bloc) => bloc.dispose(),
        onDisposeUnitialized: () {});
    return beanDefinition;
  }

  /// Pass to use:
  /// ```
  /// Module()..scopeOneDisposable<MyBloc, MyScope>((s) => MyBloc());
  /// ```
  /// With the launch of the "koin_bloc" package, this will have been
  /// renamed to avoid confusion.
  ///
  /// This will be removed in the next versions, then use 'scopeOneDisposable'.
  ///
  @deprecated
  ProviderDefinition<T> scopeOneBloc<T extends Disposable, TScope>(
    ProviderCreate<T> definition, {
    Qualifier? qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    final beanDefinition = scopeOne<T, TScope>(definition,
        qualifier: qualifier,
        createdAtStart: createdAtStart,
        override: override);
    beanDefinition.onClose((value) => value.dispose(),
        onDisposeUnitialized: () {});
    return beanDefinition;
  }
}

extension ScopeSetBlocExtension on ScopeDSL {
  /// Pass to use:
  /// ```
  /// var blocModule = Module()
  /// ..scope<ScopeWidget>((scope) {
  ///   scope.scopedDisposable<ScopedBloc>((s) => ScopedBloc());
  /// });
  /// ```
  ///
  /// With the launch of the "koin_bloc" package, this will have been
  /// renamed to avoid confusion.
  ///
  /// This will be removed in the next versions, then use 'scopedDisposable'.
  @deprecated
  ProviderDefinition<T> scopedBloc<T extends Disposable>(
    ProviderCreate<T> create, {
    Qualifier? qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    var providerDefinition =
        scoped<T>(create, qualifier: qualifier, override: override);

    providerDefinition.onClose((bloc) => bloc.dispose(),
        onDisposeUnitialized: () {});
    return providerDefinition;
  }
}
