
# Bloc Library

The `koin_bloc` package is dedicated to bring Flutter [Bloc library](https://bloclibrary.dev/#/) features.
The `koin_bloc` makes it easy to use koin with Bloc library.

## Bloc API

The `koin_bloc.dart` introduces API keywords that comes in complement of single and scoped, to help declare a Bloc or Cubit component.

- `cubit` definition, create an `single `and `close` the object at the end of the global koin context lifetime.
- `scopedCubit` definition, create an object `scoped` and `close` when the associated scope is closed(Lifetime end).

### Single 

Declaring a bloc component means that Koin container will keep a *unique instance* 
and `close` when `stopKoin` is called.


Declare you single Cubit:

```dart
// Declare bloc instance
// The 'dispose' metohod will be called at the end of the koin life time.
final myModule = module()..bloc((s) => MyCubit());

```
### Scoped 

To declare a scoped cubit definition, use the `scopedCubit` function like follow. 
The scoped instance will be automatically `closed` when the scope is closed.

```dart
// Declare scopedCubit instance.
// The 'close' metohod will be called at the end of the scope life time.
module()..scope<LoginPage>((scope){
  scope.scopedCubit((s) => LoginBloc());
});
```

##  Cubit

Example of use:

```dart

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
}

module()..scope<CounterPage>((scope){
  scope.scopedCubit((s) => CounterCubit());
});
```


##  Bloc

Example of use:

```dart

enum CounterEvent { increment, decrement }

class CounterBloc extends Bloc<CounterEvent, int>{
  CounterBloc() : super(0);

  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
    // ...
    }
  }
}

module()..scope<CounterPage>((scope){
  scope.scopedCubit((s) => CounterBloc());
});
```