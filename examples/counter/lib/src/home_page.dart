import 'package:counter/src/counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:koin/koin.dart';
import 'package:koin_flutter/koin_flutter.dart';

/// Define a koin module with a scope for `SimpleCounterPage`.
var simpleModule = Module()
  ..scope<SimpleCounterPage>((s) {
    s.scoped((s) => Counter(0));
  });

class SimpleCounterPage extends StatefulWidget {
  @override
  _SimpleCounterPageState createState() => _SimpleCounterPageState();
}

/// Using `ScopeStateMixin` to automatically close the scope when `SimpleCounterPage` is removed from the tree.
class _SimpleCounterPageState extends State<SimpleCounterPage>
    with ScopeStateMixin {
  @override
  Widget build(BuildContext context) {
    // Get the Counter of the scope instantiated for the SimpleCounterPage.
    var counter = currentScope.get<Counter>();

    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              'ScopedSingle Counter',
            ),
            Observer(
              builder: (_) {
                return Text(
                  '${counter.value}',
                  style: Theme.of(context).textTheme.display1,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

var homeModule = Module()
  ..single<Counter>((s) => Counter(0))
  ..scope<MyHomePage>((s) {
    s.scoped((s) => Counter(0));
    s.factory1<Counter, int>((s, value) => Counter(value),
        qualifier: named("Fac"));
  });

// An example of more complex usage using singles, factorys, and scopeds.
// Each instance of 'MyHomePage' in the tree receives a unique scope,
// so you can have multiple instances of MyHomePage in the tree without sharing the definitions instances between them.
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with ScopeStateMixin {
  Counter counter;
  Counter counter2;
  Counter counterSingle;

  @override
  void initState() {
    // Get the instance from root scope.
    counterSingle = get();
    // Get the factory instance of the scope defined for MyHomePage.
    counter2 = currentScope.get<Counter>(named("Fac"), parametersOf([50]));
    //Get the singleton definition of the current instantiated scope for MyHomePage.
    counter = currentScope.get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (c) {
                return MyHomePage();
              }), (smk) => false);
            },
          ),
        ],
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'ScopedSingle Counter',
            ),
            Observer(
              builder: (_) {
                return Text(
                  '${counter.value}',
                  style: Theme.of(context).textTheme.display1,
                );
              },
            ),
            Text(
              'Factory Counter',
            ),
            Observer(
              builder: (_) {
                return Text(
                  '${counter2.value}',
                  style: Theme.of(context).textTheme.display1,
                );
              },
            ),
            Text(
              'Single',
            ),
            Observer(
              builder: (_) {
                return Text(
                  '${counterSingle.value}',
                  style: Theme.of(context).textTheme.display1,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counter.increment();
          counter2.increment();
          counterSingle.increment();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
