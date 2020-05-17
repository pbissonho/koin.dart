import 'package:counter/src/counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:koin/koin.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with KoinComponentMixin {
  Counter counter;
  Counter counter2;

  @override
  void initState() {
    counter = get<Counter>();
    counter2 = get<Counter>(named("Fac"), parametersOf([50]));
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
          )
        ],
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Single Counter',
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counter.increment();
          counter2.increment();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
