A package to make it easier to use Bloc library with Koin.dart.

## Usage

Create your Cubit or Bloc

```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
}
```

```dart 
// Your scope class
class MyScope {}

var cubitModule = Module()
  // Define a single cubit.
  // Single Cubit will be closed when the global context of the koin is closed.
  ..bloc((s) => CounterCubit())
  // Define a scoped cubit for MyScopeWidget.
  // Scoped Cubit will be closed when the scope instance is closed,
  //that is, when MyScopeWidget is removed from the widget tree
  ..scope<MyScope>((scope) {
    scope.scopedBloc<CounterCubit>((scope) => CounterCubit());
  });
```  