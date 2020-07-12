import 'package:koin/koin.dart';

/// Interface that must be implemented in the business classes that use streams
/// or it is necessary to finalize some internal component.
/// The `dispose` method will be called when the scope is closed.
abstract class Disposable {
  /// Method called when the scope that this component is instantiated is closed.
  void dispose();
}

extension BlocModuleExtension on Module {
 /// Defines a BLoC as single definition that will be automatically closed.
 /// The `dispose` method of the instance created by the [definition] will be called when the global context of the koin is finalized.
 /// 
 /// Implement `Disposable` interface when the business classes use streams
 /// or it is necessary to finalize some internal component.
 /// 
 /// Implement the Disposable interface: 
 ///```
 ///class Bloc implements Disposable {
 ///
 /// @override
 /// void dispose() {
 ///   // close streams
 ///   // ...
 ///   }
 ///}
 ///```
 ///Define the bloc:
 ///```
 ///var blocModule = Module()..bloc((s) => Bloc());
 ///```
 ///
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
}

extension ScopeSetBlocExtension on ScopeDSL {
 
 /// Defines a BLoC as scoped definition that will be automatically closed when the scope is closed.
 /// The `dispose` method of the instance created by the [definition] will be called when the scope is closed.
 /// 
 /// Implement `Disposable` interface when the business classes use streams
 /// or it is necessary to finalize some internal component.
 /// 
 /// Implement the Disposable interface: 
 ///```
 ///class Bloc implements Disposable {
 ///
 /// @override
 /// void dispose() {
 ///   // close streams
 ///   // ...
 ///   }
 ///}
 ///```
 ///Defines the bloc for a scope:
 ///```
 ///var blocModule = Module()
 /// ..scope<ScopeWidget>((scope) {
 ///   scope.scopedBloc<ScopedBloc>((s) => ScopedBloc());
 /// });
 ///```
 /// 
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
