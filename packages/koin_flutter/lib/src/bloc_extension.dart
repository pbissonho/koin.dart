import 'package:koin/koin.dart';
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
  BeanDefinition<T> bloc<T extends Disposable>(
    DefinitionFunction<T> definition, {
    Qualifier qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    var beanDefinition = single<T>(definition,
        qualifier: qualifier,
        createdAtStart: createdAtStart,
        override: override);

    beanDefinition.onClose((bloc) => bloc.dispose());
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
  BeanDefinition<T> scopeOneBloc<T extends Disposable, TScope>(
    DefinitionFunction<T> definition, {
    Qualifier qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    final beanDefinition = scopeOne<T, TScope>(definition,
        qualifier: qualifier,
        createdAtStart: createdAtStart,
        override: override);
    beanDefinition.onClose((value) => value.dispose());
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
  BeanDefinition<T> scopedBloc<T extends Disposable>(
    DefinitionFunction<T> definition, {
    Qualifier qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    var beanDefinition =
        scoped<T>(definition, qualifier: qualifier, override: override);

    beanDefinition.onClose((bloc) => bloc.dispose());
    return beanDefinition;
  }
}
