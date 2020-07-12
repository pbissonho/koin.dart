import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koin/koin.dart';

import 'package:koin_flutter/src/widget_extension.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:koin_flutter/koin_bloc.dart';

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

class BlocComponentTest extends KoinComponent {
  Bloc blocX;

  BlocComponentTest() {
    blocX = get();
  }
}

class BlocComponentMixinTest with KoinComponentMixin {
  Bloc blocX;

  BlocComponentMixinTest() {
    blocX = get();
  }
}

var blocModule = Module()
  ..bloc((s) => Bloc())
  ..scope<ScopeWidget>((scope) {
    scope.scopedBloc<Bloc>((s) => Bloc());
  });

void main() {
  Koin koin;
  setUp(() {
    koin = startKoin((app) {
      app.module(blocModule);
    }).koin;
  });
  testWidgets("The block instance is disposed when the stop koin",
      (tester) async {
    var bloc = koin.get<Bloc>();
    expect(bloc, isNotNull);

    stopKoin();

    expect(bloc.isDisposed, true);
  });

  testWidgets("The block instance is disposed when the scope is closed koin",
      (tester) async {
    var scope = koin.createScopeT<ScopeWidget>('myScope', null);
    var bloc = scope.get<Bloc>();
    expect(bloc, isNotNull);
    expect(bloc.isDisposed, false);
    scope.close();
    expect(bloc.isDisposed, true);

    stopKoin();
  });

  test("can get with bloc extension component mixin", () {
    var bloc = koin.get<Bloc>();
    var component = BlocComponentMixinTest();

    expect(bloc, component.blocX);

    stopKoin();
  });

  test("can get with bloc extension component", () {
    var bloc = koin.get<Bloc>();
    var component = BlocComponentTest();

    expect(bloc, component.blocX);

    stopKoin();
  });

  testWidgets(
      'shoud close the scope when the StatefulWidget is removed from tree',
      (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(
      home: ScopeWidget(),
    ));

    stopKoin();
  });
}

class ScopeWidget extends StatefulWidget {
  @override
  KoinTestState createState() => KoinTestState();
}

class KoinTestState extends State<ScopeWidget> with ScopeStateMixin {
  Bloc myBloc;

  @override
  void initState() {
    myBloc = currentScope.get<Bloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('T'),
    );
  }
}
