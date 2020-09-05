import 'package:bloc/bloc.dart';
import 'package:koin/koin.dart';
import 'package:koin/extension.dart';
import 'package:koin/internals.dart';

extension BlocModuleExtension on Module {
  /// Defines a [Cubit] as [single] provider that will be automatically closed.
  /// The `close` method of the [Cubit] created by the [create] will be called when the global context of the koin is finalized.
  ///
  ///
  /// Define the Cubit:
  /// ```
  /// var myModule = Module()..cubit((s) => MyCubit());
  /// ```
  ///
  ProviderDefinition<T> cubit<T extends Cubit>(
    ProviderCreate<T> create, {
    Qualifier qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    var providerDefinition = single<T>(create,
        qualifier: qualifier,
        createdAtStart: createdAtStart,
        override: override);

    providerDefinition.onClose((cubit) => cubit.close());
    return providerDefinition;
  }

  /// Declare in a simplified way a scope that has
  /// only one a Cubit by [create].

  /// Declare a Cubit scoped provider [T] for scope [TScope].
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
  /// Module()..scopeOneCubit<LoginCubit, MyScope>((s) => LoginCubit());
  ///```
  ProviderDefinition<T> scopeOneCubit<T extends Cubit, TScope>(
    ProviderCreate<T> create, {
    Qualifier qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    final providerDefinition = scopeOne<T, TScope>(create,
        qualifier: qualifier,
        createdAtStart: createdAtStart,
        override: override);
    providerDefinition.onClose((cubit) => cubit.close());
    return providerDefinition;
  }
}

extension ScopeSetCubitExtension on ScopeDSL {
  /// Defines a Cubit as scoped provider that will be automatically closed when the scope is closed.
  /// The `close` method of the Cubit instance created by the [create] will be called when the scope is closed.
  ///
  ///Defines the Cubit for a scope:
  ///```
  ///var blocModule = Module()
  /// ..scope<ScopeWidget>((scope) {
  ///   scope.scopedCubit<LoginCubit>((s) => LoginCubit());
  /// });
  ///```
  ProviderDefinition<T> scopedCubit<T extends Cubit>(
    ProviderCreate<T> create, {
    Qualifier qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    var beanDefinition =
        scoped<T>(create, qualifier: qualifier, override: override);

    beanDefinition.onClose((bloc) => bloc.close());
    return beanDefinition;
  }
}
