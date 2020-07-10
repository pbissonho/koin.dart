---
title: Scope
---


The `koin_flutter` package is dedicated to bring Flutter scope features to the existing Scope API.


## Taming the Widgets lifecycle

Flutter Widgets are mainly managed by ther widget tree, that use the lifecycle functions of the Widgets, such as
`initState()` and `dispose()`.

That's why we can't describe our StatefulWidget/StatelessWidget/ in a Koin module. We need then to inject dependencies into properties and also respect the lifecycle.
Then we have:

* long live components (Services, Data Repository ...) - used by several screens, never dropped
* medium live components (BLoC) - used by several screens, must be dropped after an amount of time
* short live components (BLoC) - used by only one screen & must be dropped at the end of the screen

Long live components can be easily described as `single` definitions. For medium and short live components we can have several approaches.

In the case of BLoC pattern, the BLoC class can be used as a short or medium live component to help/support the UI. The BLoC instance must be created each time the widget is showing and dropped once widget is removed from the widget tree.

Some Blocs can be used as a long live components,for example, to control authentication,
but in most cases they are used as short or medium live.


A new Bloc is created each time

```dart
class LoginBloc extends Bloc {

    // Streams
    ...
    ...
    ...

    // Close the Streams
    void close(){

    }
```

We can describe it in a module:


* as `factory` - to produce a new instance each time the `by inject()` or `get()` is called

Using the as factory you will have to manually close the bloc.

```dart
 // Factory instance of LoginBloc
final flutterModule = Module()..factory((s) => LoginBloc());


* as `scope` - to produce an instance tied to a scope

```dart
module()..scopeWithType(named('scope_id'),(scope){
  scope.scoped((s) => LoginBloc());
});
```

## LifecycleScopeMixin

Koin gives the `LifecycleScope` mixin already bound to your Flutter `StatefulWidget` lifecycle. On `dispose()` is calld, it will close automatically. LifecycleScopeMixin overrides the `dispose` method to call the `close` method of the current scope.

To benefit from the `lifecycleScope`, you have to use the `LifecycleScopeMixin` in `StatefulWidget` related to a scope.


```dart
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

/// When LoginPage is removed from the tree the scope will be automatically closed.
class _LoginPageState extends State<LoginPage> with LifecycleScopeMixin {
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
var loginModule = Module()
  // Declare a scope to LoginPage
  ..scope<LoginPage>((s) {
    s.scoped((s) => LoginBloc());
  });
```
