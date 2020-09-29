import 'package:flutter/material.dart';
import 'package:koin/koin.dart';
import 'package:koin_flutter/koin_flutter.dart';

class MyClass {
  final int value;

  MyClass(this.value);
}

final scopeProviderModule = Module()
  ..scopeOne<MyClass, FirstPage>((scope) => MyClass(10));

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

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
