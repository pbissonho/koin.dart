import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin/koin.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:koin_bloc/koin_bloc.dart';

// An example of more complex usage using singles, factorys, and scopeds.
// Each instance of 'MyHomePage' in the tree receives a unique scope.
// so you can have multiple instances of MyHomePage in the tree without sharing the providers instances between them.
class CounterCubit extends Cubit<int> {
  CounterCubit(int intial) : super(intial);
  void increment() => emit(state + 1);
}

final homeModule = Module()
  ..cubit((s) => CounterCubit(0))

  /// Using `scopeOne` that only allows you to declare a provider.
  /// Using `scope` it is possible to declare several providers for the scope.
  ..scope<MyHomePage>((s) {
    // Declare the fist scoped provider.
    s.scopedCubit((s) => CounterCubit(0));
    s.factoryWithParam<CounterCubit, int>((s, inital) => CounterCubit(inital),
        qualifier: named("Fac"));
    // And it is possible to declare as needed
    // ...
    // ...
  });

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with ScopeStateMixin {
  @override
  Widget build(BuildContext context) {
    // Get the instance from root scope.
    CounterCubit counterSingle = get();
    // Get the factory instance of the scope defined for MyHomePage.
    CounterCubit counterFactory = currentScope
        .getWithParam<CounterCubit, int>(50, qualifier: named("Fac"));
    //Get the singleton definition of the current instantiated scope for MyHomePage.
    CounterCubit counterScoped = currentScope.get<CounterCubit>();
    return ScopeProvider(
      scope: currentScope,
      child: Scaffold(
        // Inspect the state of your instances scope.
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: Text("SetState", overflow: TextOverflow.clip),
                onPressed: () {
                  setState(() {});
                }),
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
              icon: Text("ScopeProvider", overflow: TextOverflow.clip),
              onPressed: () {
                // ScopeProvider
                // That allow to pass the current scope to another route.
                Navigator.push(context, MaterialPageRoute(builder: (c) {
                  return ScopeProvider(
                      scope: currentScope, child: UseScopePage());
                }));
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
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'ScopedSingle Counter',
                ),
                BlocBuilder(
                  bloc: counterScoped,
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
                  bloc: counterFactory,
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
                  bloc: counterSingle,
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
      ),
    );
  }
}

class UseScopePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counterScoped = context.scope.get<CounterCubit>();
    return Scaffold(
      body: Center(
        child: Text(counterScoped.state.toString()),
      ),
    );
  }
}
