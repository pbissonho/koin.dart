import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin_and_bloc/scoped_component.dart';

import 'blocs/counter_bloc.dart';

class CounterPage extends StatelessWidget with Injector {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => inject<CounterBloc>(context));
  }
}

class MyPage extends StatelessWidget with Injector {
  final String title;

  const MyPage({Key key, this.title = "Value"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = inject<CounterBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: StreamBuilder(
        stream: bloc,
        builder: (context, snap) {
          return Center(child: Text(snap.data.toString()));
        },
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              heroTag: "Hero",
              child: Icon(Icons.add),
              onPressed: () {
                bloc.add(CounterEvent.increment);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: Icon(Icons.navigate_next),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => CounterWidget()));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CounterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Text("Test"),
        ),
      ),
    );
  }
}
