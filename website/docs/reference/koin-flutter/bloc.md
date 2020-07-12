---
title: BLoC Pattern
---

The `koin_bloc.dart` import is dedicated to bring Flutter BLoC Pattern features.

:::info
The `koin_bloc.dart` makes it easy to use koin with any state management package that uses streams behind the scenes.
:::

## Bloc DSL

The `koin_bloc.dart` introduces DSL keywords that comes in complement of single and scoped, to help declare a Bloc component.

- `bloc` definition, create an `single `and close the object at the end of the global koin context lifetime.
- `scopedBloc` definition, create an object `scoped` and `dispose` when the associated scope is closed(Lifetime end).

### Single Bloc

Declaring a bloc component means that Koin container will keep a *unique instance* 
and `dispose` when `stopKoin` is called.

Your declared bloc component must implement the `Disposable` interface.

```dart

class Bloc implements Disposable {

  @override
  void dispose() {
    // close streams
  }
}

// Declare bloc instance
// The 'dispose' metohod will be called at the end of the koin life time.
final myModule = module()..bloc((s) => MyBloc());

```
### Scoped Bloc

To declare a scoped bloc definition, use the `scopedBloc` function like follow. 
The scoped instance will be automatically `disposed` when the scope is closed.

```dart
// Declare scopedBloc instance.
// The 'dispose' metohod will be called at the end of the scope life time.
// Using ScopeStateMixin, it is done automatically.
module()..scope<LoginPage>((scope){
  scope.scopedBloc((s) => LoginBloc());
});
```

##  Bloc

Example of use with the Felix [bloc](https://pub.dev/packages/bloc) library.

```dart

enum CounterEvent { increment, decrement }

class CounterBloc extends Bloc<CounterEvent, int> implements Disposable {
  CounterBloc() : super(0);

  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
    // ...
    }
  }

  // Close the Bloc.
  void dispose() => close();
}

module()..scope<CounterPage>((scope){
  scope.scopedBloc((s) => CounterBloc());
});
```

##  Cubit

Example of use with [Cubit](https://pub.dev/packages/cubit).

```dart

class CounterCubit extends Cubit<int> implements Disposable{
  CounterCubit() : super(0);

  void increment() => emit(state + 1);

  // Close the Cubit.
  void dispose() => close();
}

module()..scope<CounterPage>((scope){
  scope.scopedBloc((s) => CounterCubit());
});
```
