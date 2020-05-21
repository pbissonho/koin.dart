import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koin/koin.dart';

import '../lib/src/bloc_ext/bloc_extension.dart';

abstract class Teteca {
  void dispose();
}

class Bloc extends Teteca with Disposable {
  bool isDisposed = false;

  @override
  void dispose() {
    isDisposed = true;
  }
}

class ScopedBloc implements Disposable {
  @override
  void dispose() {}
}

var blocModule = Module()
  ..bloc((s) => Bloc())
  ..scope<ScopeWidget>((scope) {
    scope.scopedBloc<ScopedBloc>((s) => ScopedBloc());
  });

void main() {
  testWidgets("Test", (tester) async {
    var koin = startKoin((app) {
      app.module(blocModule);
    }).koin;

    var bloc = koin.get<Bloc>();
    expect(bloc, isNotNull);

    stopKoin();

    expect(bloc.isDisposed, true);
  });
}

class ScopeWidget extends StatefulWidget {
  @override
  KoinTestState createState() => KoinTestState();
}

class KoinTestState extends State<ScopeWidget> with KoinComponentMixin {
  Bloc myBloc;
  @override
  void initState() {
    myBloc = bloc<Bloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('T'),
    );
  }
}
