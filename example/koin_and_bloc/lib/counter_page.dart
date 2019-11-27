import 'package:flutter/material.dart';
import 'package:koin/koin.dart';
import 'package:koin_and_bloc/scoped_component.dart';
import 'counter_bloc.dart';
import 'di.dart';

class CounterScopePage extends StatefulWidget {
  @override
  _CounterScopePageState createState() => _CounterScopePageState();
}

class _CounterScopePageState extends State<CounterScopePage>
    with ScopedComponent {
  @override
  Widget build(BuildContext context) {
    CounterBloc counterBloc = currentScope.inject<CounterBloc>();
    CounterBloc singletonBloc = inject<CounterBloc>();

    Teste test = inject<Teste>(parameters: [Tuca()]);

    Teste currentTest = currentScope.inject<Teste>();

    return Scaffold(
      appBar: AppBar(title: Text('CounterScopePage')),
      body: Column(
        children: <Widget>[
          StreamBuilder<int>(
            stream: counterBloc,
            builder: (context, snap) {
              return Center(
                child: Text(
                  'Current:${snap.data}',
                  style: TextStyle(fontSize: 24.0),
                ),
              );
            },
          ),
          StreamBuilder<int>(
            stream: singletonBloc,
            builder: (context, snap) {
              return Center(
                child: Text(
                  'Singleton: ${snap.data}',
                  style: TextStyle(fontSize: 24.0),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                counterBloc.add(CounterEvent.increment);
              },
            ),
          ),
          /*
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: Icon(Icons.remove),
              onPressed: () {
                counterBloc.add(CounterEvent.decrement);
              },
            ),
          ),*/
        ],
      ),
    );
  }
}

class CounterPage extends StatelessWidget with InjectComponent {
  @override
  Widget build(BuildContext context) {
    CounterBloc counterBloc = inject<CounterBloc>();
    CounterBloc counterBloc2 = inject<CounterBloc>(named("Counter2"));

    return Scaffold(
      appBar: AppBar(title: Text('Counter')),
      body: Column(
        children: <Widget>[
          Text("ScopeCounter"),
          MaterialButton(
            height: 20,
            child: Text(
              "CounterScope",
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => CounterScopePage()));
            },
          ),
          StreamBuilder<int>(
            stream: counterBloc,
            builder: (context, snap) {
              return Center(
                child: Text(
                  '${snap.data}',
                  style: TextStyle(fontSize: 24.0),
                ),
              );
            },
          ),
          StreamBuilder<int>(
            stream: counterBloc2,
            builder: (context, snap) {
              return Center(
                child: Text(
                  'CounterBloc2:${snap.data}',
                  style: TextStyle(fontSize: 24.0),
                ),
              );
            },
          )
        ],
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                counterBloc2.add(CounterEvent.increment);
                counterBloc2.add(CounterEvent.increment);
                counterBloc.add(CounterEvent.increment);
              },
            ),
          ),
        ],
      ),
    );
  }
}
