import 'package:counter/src/counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:koin/koin.dart';
import 'package:koin_flutter/koin_flutter.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Counter counter;
  Counter counter2;
  Counter counterSingle;

  @override
  void initState() {
    counterSingle = get();
    counter2 = currentScope.get<Counter>(named("Fac"), parametersOf([50]));
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
