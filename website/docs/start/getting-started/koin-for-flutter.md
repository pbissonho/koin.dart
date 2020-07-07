---
title: Koin for Flutter
---
## Starting Koin for Flutter

In any Flutter Widget:

```dart
void main() {
  startKoin((app) {
    app.printLogger(level: Level.debug);
    app.module(myModule);
  });
  runApp(MyApp());
}
```

## Flutter Components as KoinComponents

`Widgets`, are extended by Koin to be considered as `KoinComponents` out of the box:

```dart
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc bloc;
  Lazy<LoginBloc> lazyBloc;

  @override
  void initState() {
    // Lazy Inject MyPresenter
    lazyBloc = currentScope.inject();

    // or directly retrieve instance
    bloc = get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

Those classes can then use:

* `get()` or `by inject()` instance retrieving
* `getKoin()` to access th current `Koin` instance

If you need to inject dependencies from another class and can't declare it in a module, you can still tag it with `KoinComponent` interface.

## Extended Scope API 

> for Fluter 

Scope API is more close to the Flutter platform. Both `StatefulWidget` & `StatelessWidget` have extensions for Scope API: `currentScope` get the current associated Koin scope. This scope is created & bound to the component's lifecycle.

You can use directly the associated Koin scope to retrieve components:

```dart
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc loginBlock;

  @override
  void initState() {
    // or directly retrieve instance
    loginBlock = currentScope.get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```



Easy to declare your Flutter Widgets's scope:

```dart
var loginModule = Module()
  // Declare a scope to LoginPage
  ..scope<LoginPage>((s) {
    s.scoped((s) => LoginBloc());
  });

```

Any Widget can use directly the scope API: `createScope()`, `getScope()` and `deleteScope()`.


