import 'package:bloc/bloc.dart';
import 'package:koin/koin.dart';
import 'package:koin/extension.dart';
import 'package:koin/internals.dart';

extension BlocModuleExtension on Module {
  /// Defines a [BlocBase] as [single] provider that will be automatically closed.
  /// The `close` method of the [BlocBase] created by the [create] will be called when the global context of the koin is finalized.
  ///
  ///
  /// Define the Cubit or Bloc:
  /// ```
  /// final myModule = Module()..bloc((s) => MyBloc());
  ///
  ///
  /// or
  ///
  /// final myModule = Module()..bloc((s) => MyCubit());
  ///
  /// ```
  ///
  ProviderDefinition<T> bloc<T extends BlocBase>(
    ProviderCreate<T> create, {
    Qualifier? qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    final providerDefinition = single<T>(create,
        qualifier: qualifier,
        createdAtStart: createdAtStart,
        override: override);

    providerDefinition.onClose((cubit) => cubit.close(),
        onDisposeUnitialized: () {});
    return providerDefinition;
  }

  /// Declare in a simplified way a scope that has
  /// only one a BlocBase by [create].

  /// Declare a BlocBase scoped provider [T] for scope [TScope].
  /// Declare and define a scoped with just one line.

  ///
  ///Standard: Used when it is necessary to declare several
  ///providers for a scope.
  ///```
  ///  ..scope<Login>((s) {
  ///  s.scopedStream((s) => LoginCubit(s.get()));
  ///})
  ///```
  /// Declare a scope and define a scoped provider with just one line:
  ///```
  /// Module()..scopeOneBloc<LoginCubit, MyScope>((s) => LoginCubit());
  ///```
  ProviderDefinition<T> scopeOneBloc<T extends BlocBase, TScope>(
    ProviderCreate<T> create, {
    Qualifier? qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    final providerDefinition = scopeOne<T, TScope>(create,
        qualifier: qualifier,
        createdAtStart: createdAtStart,
        override: override);
    providerDefinition.onClose((bloc) => bloc.close(),
        onDisposeUnitialized: () {});
    return providerDefinition;
  }
}

extension ScopeSetCubitExtension on ScopeDSL {
  /// Defines a BlocBase as scoped provider that will be automatically closed when the scope is closed.
  /// The `close` method of the BlocBase instance created by the [create] will be called when the scope is closed.
  ///
  ///Defines the BlocBase for a scope:
  ///```
  ///final blocModule = Module()
  /// ..scope<ScopeWidget>((scope) {
  ///   scope.scopedBloc<LoginCubit>((s) => LoginCubit());
  /// });
  ///```
  ProviderDefinition<T> scopedBloc<T extends BlocBase>(
    ProviderCreate<T> create, {
    Qualifier? qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    final providerDefinition =
        scoped<T>(create, qualifier: qualifier, override: override);

    providerDefinition.onClose((bloc) => bloc.close(),
        onDisposeUnitialized: () {});
    return providerDefinition;
  }
}
