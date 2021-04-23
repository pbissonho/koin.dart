import 'package:koin/extension.dart';
import 'package:koin/internals.dart';
import 'package:koin/koin.dart';

/// Interface that must be implemented in the business classes that use streams
/// or it is necessary to finalize some internal component.
/// The `dispose` method will be called when the scope is closed.
abstract class Disposable {
  /// Method called when the scope that this component
  /// is instantiated is closed.
  void dispose();
}

/// Introduces `disposable` and  `scopeOneDisposable` keywords that comes in
/// complement of single and scoped,to help declare disposable component.
///
/// Facilitates the use of Koin with state management that
/// depends on the flow controllers that need to be closed.
extension DisposableModuleExtension on Module {
  /// Defines a `Disposable` as single [create] that will be automatically
  /// closed.
  ///
  /// The `dispose` method of the instance created by the [create] will
  /// be called when the global context of the koin is finalized.
  ///
  /// Implement `Disposable` interface when the business classes use streams
  /// or it is necessary to finalize some internal component.
  ///
  /// Implement the `Disposable` interface:
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
  ProviderDefinition<T> disposable<T extends Disposable>(
    ProviderCreate<T> create, {
    Qualifier? qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    var beanDefinition = single<T>(create,
        qualifier: qualifier,
        createdAtStart: createdAtStart,
        override: override);

    beanDefinition.onClose((bloc) => bloc.dispose(),
        onDisposeUnitialized: () {});
    return beanDefinition;
  }

  /// Declare in a simplified way a scope that has
  /// only one Bloc [definition].

  /// Declare a Bloc scoped definition [T] for scope [TScope].
  /// Declare and define a scoped with just one line.

  ///
  ///Standard: Used when it is necessary to declare several
  ///definitions for a scope.
  ///```
  ///  ..scope<Login>((s) {
  ///  s.scopedBloc((s) => LoginBloc(s.get()));
  ///})
  ///```
  /// Declare a scope and define a scoped with just one line:
  ///```
  /// Module()..scopeOne<MyBloc, MyScope>((s) => MyBloc());
  ///```
  ProviderDefinition<T> scopeOneDisposable<T extends Disposable, TScope>(
    ProviderCreate<T> create, {
    Qualifier? qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    final beanDefinition = scopeOne<T, TScope>(create,
        qualifier: qualifier,
        createdAtStart: createdAtStart,
        override: override);
    beanDefinition.onClose((value) => value.dispose(),
        onDisposeUnitialized: () {});
    return beanDefinition;
  }
}

extension ScopeSetDisposableExtension on ScopeDSL {
  /// Defines a BLoC as scoped [definition] that will be automatically
  /// closed when the scope is closed.
  ///
  /// The `dispose` method of the instance created by the [definition] will
  /// be called when the scope is closed.
  ///
  /// Implement `Disposable` interface when the business classes use streams
  /// or it is necessary to finalize some internal component.
  ///
  /// Implement the `Disposable` interface:
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
  ProviderDefinition<T> scopedDisposable<T extends Disposable>(
    ProviderCreate<T> create, {
    Qualifier? qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    var beanDefinition =
        scoped<T>(create, qualifier: qualifier, override: override);

    beanDefinition.onClose((bloc) => bloc.dispose(),
        onDisposeUnitialized: () {});
    return beanDefinition;
  }
}
