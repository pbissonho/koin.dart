import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin/koin.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:koin_bloc/koin_bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit(int intial) : super(intial);

  void increment() => emit(state + 1);
}

/// Define a koin module with a scope for `SimpleCounterPage`.
/// Here, the `SimpleCounterPage` scope is being defined, which contains a provider for `CounterCubit`.
final simpleModule = Module()
  ..scopeOneCubit<CounterCubit, SimpleCounterPage>((_) => CounterCubit(0));

class SimpleCounterPage extends StatefulWidget {
  @override
  _SimpleCounterPageState createState() => _SimpleCounterPageState();
}

/// Using `ScopeStateMixin` to automatically close the scope when `SimpleCounterPage` is removed from the tree.
class _SimpleCounterPageState extends State<SimpleCounterPage>
    with ScopeStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: <Widget>[
          BlocBuilder<CounterCubit, int>(
              // Get the Counter of the scope instantiated for the SimpleCounterPage.
              bloc: currentScope.get<CounterCubit>(),
              builder: (BuildContext context, state) => Text(state.toString())),
        ],
      )),
    );
  }
}
