import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koin/koin.dart';
import 'package:koin_flutter/koin_bloc.dart';

class Bloc implements Disposable {
  @override
  void dispose() {}
}

class ScopedBloc implements Disposable {
  @override
  void dispose() {}
}

var blocModule = Module()
  ..bloc((s, p) => Bloc())
  ..scope(named<ScopeWidget>(), (scope) {
    scope.scopedBloc<ScopedBloc>((s, p) => ScopedBloc());
  });

void main() {
  testWidgets("description", (tester) async {
    startKoin((app) {
      app.module(blocModule);
    });

    await tester.pumpWidget(MaterialApp(home: ScopeWidget()));

    final titleFinder = find.text('T');

    expect(titleFinder, findsOneWidget);
  });
}

class ScopeWidget extends StatefulWidget {
  @override
  _KoinTestState createState() => _KoinTestState();
}

class _KoinTestState extends State<ScopeWidget> with ScopeComponentMixin {
  Bloc myBloc;
  @override
  void initState() {
    myBloc = bloc<Bloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("T"),
    );
  }
}
