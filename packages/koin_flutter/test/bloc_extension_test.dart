import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koin/koin.dart';

import 'package:koin/instace_scope.dart';
import '../lib/src/bloc_ext/bloc_extension.dart';

abstract class BlocBase {
  void dispose();
}

class Bloc extends BlocBase with Disposable {
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

class BlocComponentTest extends KoinComponent {
  Bloc blocX;

  BlocComponentTest() {
    blocX = bloc();
  }
}

class BlocComponentMixinTest with KoinComponentMixin {
  Bloc blocX;

  BlocComponentMixinTest() {
    blocX = bloc();
  }
}

var blocModule = Module()
  ..bloc((s) => Bloc())
  ..scope<ScopeWidget>((scope) {
    scope.scopedBloc<ScopedBloc>((s) => ScopedBloc());
  });

void main() {
  testWidgets("The block instance is disposed when the stop koin",
      (tester) async {
    var koin = startKoin((app) {
      app.module(blocModule);
    }).koin;

    var bloc = koin.get<Bloc>();
    expect(bloc, isNotNull);

    stopKoin();

    expect(bloc.isDisposed, true);
  });

  test("can get with bloc extension component mixin", () {
    var koin = startKoin((app) {
      app.module(blocModule);
    }).koin;

    var bloc = koin.get<Bloc>();
    var component = BlocComponentMixinTest();

    expect(bloc, component.blocX);

    stopKoin();
  });

  test("can get with bloc extension component", () {
    var koin = startKoin((app) {
      app.module(blocModule);
    }).koin;

    var bloc = koin.get<Bloc>();
    var component = BlocComponentTest();

    expect(bloc, component.blocX);

    stopKoin();
  });
}

class ScopeWidget extends StatefulWidget {
  @override
  KoinTestState createState() => KoinTestState();
}

class KoinTestState extends State<ScopeWidget> {
  Bloc myBloc;

  @override
  void initState() {
    myBloc = widget.scope.get<Bloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('T'),
    );
  }
}
