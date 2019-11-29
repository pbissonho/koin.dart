import 'package:flutter/material.dart';
import 'package:koin_and_bloc/counter_bloc.dart';
import 'package:koin_and_bloc/scope_provider.dart';
import 'package:koin_and_bloc/scoped_component.dart';

class ScopePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopeProvider.root(child: MyPage());
  }
}

class MyPage extends StatelessWidget with Injector {
  @override
  Widget build(BuildContext context) {
    var bloc = inject<CounterBloc>(context);

    return Scaffold(
      body: CounterWidget(),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                bloc.add(CounterEvent.increment);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CounterWidget extends StatelessWidget with Injector {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: inject<CounterBloc>(context),
      builder: (context, snap) {
        return Center(
          child: Text(
            'Value:${snap.data}',
            style: TextStyle(fontSize: 24.0),
          ),
        );
      },
    );
  }
}
