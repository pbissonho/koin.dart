import 'package:koin/koin.dart';
import 'package:flutter/material.dart';

class Counter {
  int _counter = 0;

  int get counter => _counter;

  void increment() {
    _counter++;
  }

  void decrement() {
    _counter--;
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with KoinComponentMixin {
  Counter counterController;
  Counter namedCounter;

  @override
  void initState() {
    counterController = get<Counter>();
    namedCounter = get(named("CounterX"));
    super.initState();
  }

  @override
  void dispose() {
    stopKoin();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${counterController.counter}',
              style: Theme.of(context).textTheme.display1,
            ),
            Text(
              'Named counter: ${namedCounter.counter}',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            counterController.increment();
            namedCounter..increment()..increment();
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
