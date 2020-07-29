import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin/koin.dart';
import 'package:koin_devtools/koin_devtools.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:koin_bloc/koin_bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit(int intial) : super(intial);

  void increment() => emit(state + 1);

  @override
  Future<void> close() async {
    print('[CounterCubit] - Closed State: $state');
    super.close();
  }

  @override
  String toString() {
    return "State: $state";
  }
}

/// Define a koin module with a scope for `SimpleCounterPage`.
/// Define a scope and definition with just one line.
/// Here, the `SimpleCounterPage` scope is being defined, which contains a definition for `CounterCubit`.
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
      endDrawer: KoinDevTools(),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              'Scoped Counter',
            ),
            BlocBuilder<CounterCubit, int>(
              // Get the Counter of the scope instantiated for the SimpleCounterPage.
              cubit: currentScope.get<CounterCubit>(),
              builder: (BuildContext context, state) {
                return Text(state.toString());
              },
            )
          ],
        ),
      ),
    );
  }
}

final homeModule = Module()
  ..cubit<CounterCubit>((s) => CounterCubit(0))

  /// Using `scopeOne` that only allows you to declare a definition.
  /// Using `scope` it is possible to declare several definitions for the scope.
  ..scope<MyHomePage>((s) {
    s.scopedCubit((s) => CounterCubit(0));
    s.factory1<CounterCubit, int>((s, inital) => CounterCubit(inital),
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
  @override
  Widget build(BuildContext context) {
    // Get the instance from root scope.
    final counterSingle = get<CounterCubit>();
    // Get the factory instance of the scope defined for MyHomePage.
    final counterFactory =
        currentScope.get<CounterCubit>(named("Fac"), parametersOf([50]));
    //Get the singleton definition of the current instantiated scope for MyHomePage.
    final counterScoped = currentScope.get<CounterCubit>();
    return Scaffold(
      // Inspect the state of your instances scope.
      endDrawer: KoinDevTools(),
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Text("PushAndRemoveUntil", overflow: TextOverflow.clip),
            onPressed: () {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (c) {
                return MyHomePage();
              }), (smk) => false);
            },
          ),
          IconButton(
            icon: Text("Push"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (c) {
                return MyHomePage();
              }));
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
            BlocBuilder(
              cubit: counterScoped,
              builder: (BuildContext context, state) {
                return Text(
                  state.toString(),
                  style: Theme.of(context).textTheme.headline1,
                );
              },
            ),
            Text(
              'Factory Counter',
            ),
            BlocBuilder(
              cubit: counterFactory,
              builder: (BuildContext context, state) {
                return Text(
                  state.toString(),
                  style: Theme.of(context).textTheme.headline1,
                );
              },
            ),
            Text(
              'Single',
            ),
            BlocBuilder(
              cubit: counterSingle,
              builder: (BuildContext context, state) {
                return Text(
                  state.toString(),
                  style: Theme.of(context).textTheme.headline1,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counterScoped.increment();
          counterFactory.increment();
          counterSingle.increment();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
