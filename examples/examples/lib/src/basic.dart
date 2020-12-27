import 'package:koin/koin.dart';
import 'package:flutter/material.dart';
import 'package:koin_flutter/koin_flutter.dart';

// This is a simple example that makes use of setState
// to make the example accessible to new Flutter developers.

// In the 'counter' example you will find a more complete
// example using the Bloc library for state management.

// Define your Counter
var basicModule = Module()..single((s) => Counter());

//A simple Counter to be used with setState
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

class CounterPage extends StatefulWidget {
  CounterPage({Key key}) : super(key: key);

  @override
  _MyCounterPageState createState() => _MyCounterPageState();
}

class _MyCounterPageState extends State<CounterPage> with ScopeStateMixin {
  Counter counter;

  @override
  void initState() {
    // Resolve the single counter instance
    counter = get<Counter>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Counter page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${counter.counter}',
              style: Theme.of(context).textTheme.headline1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Increment your counter using setState
          setState(() {
            counter.increment();
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
