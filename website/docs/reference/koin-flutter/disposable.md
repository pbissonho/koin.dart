---
title: Disposable
---

The `koin_disposable.dart` import is dedicated to bring Flutter BLoC Pattern features.

:::info
The `koin_disposable.dart` makes it easy to use koin with any state management package that uses streams behind the scenes.
:::

## Bloc DSL

The `koin_disposable.dart` introduces DSL keywords that comes in complement of single and scoped, to help declare a Bloc component.

- `disposable` definition, create an `single `and `dispose` the object at the end of the global koin context lifetime.
- `scopedDisposable` definition, create an object `scoped` and `dispose` when the associated scope is closed(Lifetime end).

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
final myModule = module()..disposable((s) => MyBloc());

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

