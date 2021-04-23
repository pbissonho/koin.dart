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

`StatefulWidget`, are extended by Koin to be considered as `KoinComponent` out of the box:

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
   
    // directly retrieve instance
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

* `get()` instance retrieving
* `getKoin()` to access th current `Koin` instance

If you need to inject dependencies from another class and can't declare it in a module, you can still tag it with `KoinComponent` interface.

## Extended Scope API 

Scope API is more close to the Flutter platform. The `StatefulWidget`  have extensions for Scope API: `currentScope` get the current associated Koin scope.  

Koin gives the `ScopeStateMixin` mixin already bound to your Flutter `StatefulWidget` lifecycle. On `dispose()` is calld, it will close automatically. ScopeStateMixin overrides the `dispose` method to call the `close` method of the current scope.

You can use the `ScopeStateMixin` in `StatefulWidget` to close automatically the scope when the widget is removed from the tree. Whenever there is a scope associated with a `StatefulWidget` you must use the `ScopeStateMixin` or manually call the `currentScope.close`" function in the `dispose` lifecycle widget function.

:::important
If the `ScopeStateMixin` is not used and you do not call `currentScope.close` the instantiated scope for each instance of this Widget will not be closed, that is, the StatefulWidget will be removed from the tree, but the scope associated with it will remain in memory.
:::
You can use directly the associated Koin scope to retrieve components:

Easy to declare your Flutter Widgets's scope:


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

```dart
final loginModule = Module()
  // Declare a scope to LoginPage
  ..scope<LoginPage>((s) {
    s.scoped((s) => LoginBloc());
  });
```


Any StatefulWidget can use directly the scope API: `createScope()`, `getScope()` and `deleteScope()`.


