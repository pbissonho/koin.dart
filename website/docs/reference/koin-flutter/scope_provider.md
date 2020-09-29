---
title: ScopeProvider
---
A widget that allows you to propagate a scope through the widget tree. Useful when you need to access the same scope on different routes(Pages).


## Writing a module

First define a module with a scope.


```dart
class MyClass {
  final int value;

  MyClass(this.value);
}

final myModule = Module()..scopeOne<MyClass, FirstPage>((scope) => MyClass(10));
```

## Writing a page

As this page has a scope it is possible to access it directly through the "currentScope".
When navigating to the second page you will be using ScopeProvider to allow the SecondPage to access
the scope of the FirstPage.

```dart
class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with ScopeStateMixin {
  @override
  Widget build(BuildContext context) {
    final bloc = currentScope.get<MyClass>();
    return Scaffold(
        appBar: AppBar(
          title: Text("Home Page"),
        ),
        body: Column(
          children: [
            Center(
              child: Text(bloc.value.toString()),
            ),
            FlatButton(
              color: Colors.red,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  
                  // Using the ScopeProvider to provide the FirstPage scope for the SecondPage.
                  return ScopeProvider(
                      child: SecondPage(), scope: currentScope);
                }));
              },
              child: Text("Push Second Page"),
            ),
          ],
        ));
  }
}
```

## The second page

As the second page will access a scope provided by ScopeProvider, the way to access it is a little different.
You will need to access the scope by context, using 'context.scope' instead of 'currentScope'.


```dart
class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieves the scope passed by the FirstPage.
    // The bloc instance is the same as the FirstPage.
    final bloc = context.scope.get<MyClass>();
    return Scaffold(
      body: Center(
        child: Text(bloc.value.toString()),
      ),
      appBar: AppBar(
        title: Text("Second Page"),
      ),
    );
  }
}
```