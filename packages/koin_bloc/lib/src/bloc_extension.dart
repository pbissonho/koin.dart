import 'package:bloc/bloc.dart';
import 'package:koin/koin.dart';

extension BlocModuleExtension on Module {
  /// Defines a Cubit as single definition that will be automatically closed.
  /// The `close` method of the Cubit created by the [definition] will be called when the global context of the koin is finalized.
  ///
  ///
  ///Define the Cubit:
  ///```
  ///var myModule = Module()..cubit((s) => MyCubit());
  ///```
  ///
  BeanDefinition<T> cubit<T extends Cubit>(
    DefinitionFunction<T> definition, {
    Qualifier qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    var beanDefinition = single<T>(definition,
        qualifier: qualifier,
        createdAtStart: createdAtStart,
        override: override);

    beanDefinition.onClose((cubit) => cubit.close());
    return beanDefinition;
  }

  /// Declare in a simplified way a scope that has
  /// only one a Cubit [definition].

  /// Declare a Cubit scoped definition [T] for scope [TScope].
  /// Declare and define a scoped with just one line.

  ///
  ///Standard: Used when it is necessary to declare several
  ///definitions for a scope.
  ///```
  ///  ..scope<Login>((s) {
  ///  s.scopedStream((s) => LoginCubit(s.get()));
  ///})
  ///```
  /// Declare a scope and define a scoped with just one line:
  ///```
  /// Module()..scopeOneCubit<LoginCubit, MyScope>((s) => LoginCubit());
  ///```
  BeanDefinition<T> scopeOneCubit<T extends Cubit, TScope>(
    DefinitionFunction<T> definition, {
    Qualifier qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    final beanDefinition = scopeOne<T, TScope>(definition,
        qualifier: qualifier,
        createdAtStart: createdAtStart,
        override: override);
    beanDefinition.onClose((cubit) => cubit.close());
    return beanDefinition;
  }
}

extension ScopeSetCubitExtension on ScopeDSL {
  /// Defines a Cubit as scoped definition that will be automatically closed when the scope is closed.
  /// The `close` method of the Cubit instance created by the [definition] will be called when the scope is closed.
  ///
  ///Defines the Cubit for a scope:
  ///```
  ///var blocModule = Module()
  /// ..scope<ScopeWidget>((scope) {
  ///   scope.scopedCubit<LoginCubit>((s) => LoginCubit());
  /// });
  ///```
  BeanDefinition<T> scopedCubit<T extends Cubit>(
    DefinitionFunction<T> definition, {
    Qualifier qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    var beanDefinition =
        scoped<T>(definition, qualifier: qualifier, override: override);

    beanDefinition.onClose((bloc) => bloc.close());
    return beanDefinition;
  }
}
