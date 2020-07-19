import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koin/koin.dart';
import 'package:koin_flutter/src/widget_extension.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:koin_flutter/koin_bloc.dart';

import 'package:koin_test/koin_test.dart';

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

var testModule1 = Module()
  ..bloc((s) => Bloc())
  ..scope<ScopeWidget>((scope) {
    scope.scopedBloc<Bloc>((s) => Bloc());
  });

var testModule2 = Module()
  ..bloc((s) => Bloc())
  ..scope<UseScopeWidget>((scope) {
    scope.scopedBloc<Bloc>((s) => Bloc());
  });

var testModule3 = Module()
  ..bloc((s) => Bloc())
  ..scope<UseScopeExtensionWidget>((scope) {
    scope.scopedBloc<Bloc>((s) => Bloc());
  });

final buttonKey = UniqueKey();
final fisrtPage = UniqueKey();
final secondPageKey = UniqueKey();

class ScopeWidget extends StatefulWidget {
  @override
  ScopeWidgetState createState() => ScopeWidgetState();
}

class ScopeWidgetState extends State<ScopeWidget> with ScopeStateMixin {
  Bloc bloc;

  @override
  void initState() {
    bloc = currentScope.get<Bloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: fisrtPage,
      body: Container(),
      bottomNavigationBar: GestureDetector(
        key: buttonKey,
        child: Icon(Icons.add),
        onTap: () {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return SecondPage();
          }), (t) => false);
        },
      ),
    );
  }
}

class WidgetNotUseScope extends StatefulWidget {
  @override
  WidgetNotUseScopeState createState() => WidgetNotUseScopeState();
}

class WidgetNotUseScopeState extends State<WidgetNotUseScope>
    with ScopeStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: fisrtPage,
      body: Container(),
      bottomNavigationBar: GestureDetector(
        key: buttonKey,
        child: Icon(Icons.add),
        onTap: () {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return SecondPage();
          }), (router) => false);
        },
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: secondPageKey,
      body: Container(
        child: Column(
          children: <Widget>[
            Text("Test"),
          ],
        ),
      ),
    );
  }
}

class UseScopeWidget extends StatefulWidget {
  @override
  UseScopeWidgetState createState() => UseScopeWidgetState(scope.get<Bloc>());
}

class UseScopeWidgetState extends State<UseScopeWidget> with ScopeStateMixin {
  final Bloc myBloc;

  UseScopeWidgetState(this.myBloc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: fisrtPage,
      body: Container(),
      bottomNavigationBar: GestureDetector(
        key: buttonKey,
        child: Icon(Icons.add),
        onTap: () {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return SecondPage();
          }), (t) => false);
        },
      ),
    );
  }
}

class UseScopeExtensionWidget extends StatefulWidget {
  @override
  UseScopeExtensionWidgetState createState() => UseScopeExtensionWidgetState();
}

class UseScopeExtensionWidgetState extends State<UseScopeExtensionWidget> {
  Bloc myBloc;

  @override
  void initState() {
    super.initState();
    myBloc = currentScope.get();
  }

 // Close the scope manually.
  @override
  void dispose() {
    currentScope.close();
    super.dispose();
  }

  UseScopeExtensionWidgetState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: fisrtPage,
      body: Container(),
      bottomNavigationBar: GestureDetector(
        key: buttonKey,
        child: Icon(Icons.add),
        onTap: () {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return SecondPage();
          }), (t) => false);
        },
      ),
    );
  }
}

void main() {
  Koin koin;
  group('bloc extension', () {
    setUp(() {
      koin = startKoin((app) {
        app.module(testModule1);
      }).koin;
    });

    testWidgets("the bloc instance is disposed when the stop koin",
        (tester) async {
      var bloc = koin.get<Bloc>();
      expect(bloc, isNotNull);

      stopKoin();

      expect(bloc.isDisposed, true);
    });

    testWidgets("the bloc instance is disposed when the scope is closed koin",
        (tester) async {
      var scope = koin.createScope<ScopeWidget>('myScope');
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
  });

  group('ScopeStateMixin', () {
    koinSetUp();
    koinTearDown();

    final fisrtPageFinder = find.byKey(fisrtPage);
    final secondPageFinder = find.byKey(secondPageKey);
    final gestureFinder = find.byType(GestureDetector);

    testWidgets(
        'the scope should not be created - when scope() or currentScope() is not called',
        (tester) async {
      loadKoinModule(testModule1);

      final scopeWidget = WidgetNotUseScope();
      await tester.pumpWidget(MaterialApp(
        home: scopeWidget,
      ));

      expect(fisrtPageFinder, findsOneWidget);

      var scope = KoinContextHandler.get().getScopeOrNull(scopeWidget.scopeId);
      await tester.pumpAndSettle();
      expect(scope, null);
    });

    testWidgets(
        'shoud not create a scope for the StatefulWidget - when the scope() or currentScope() not is called at least once',
        (tester) async {
      loadKoinModule(testModule1);
      final scopeWidget = ScopeWidget();
      await tester.pumpWidget(MaterialApp(
        home: scopeWidget,
      ));

      expect(fisrtPageFinder, findsOneWidget);

      var scope = KoinContextHandler.get().getScopeOrNull(scopeWidget.scopeId);
      expect(scope, isNotNull);
    });

    group('shoud close scope ', () {
      testWidgets(
          'when the StatefulWidget is removed from tree - scope started by currentScope() method',
          (WidgetTester tester) async {
        // Create the widget by telling the tester to build it.
        loadKoinModule(testModule1);
        final scopeWidget = ScopeWidget();
        await tester.pumpWidget(MaterialApp(
          home: scopeWidget,
        ));

        expect(fisrtPageFinder, findsOneWidget);

        var scope = KoinContextHandler.get().getScope(scopeWidget.scopeId);

        var bloc = scope.get<Bloc>();

        expect(bloc.isDisposed, false);

        await tester.tap(gestureFinder);
        await tester.pumpAndSettle();

        expect(bloc.isDisposed, true);

        expect(secondPageFinder, findsOneWidget);
      });

      testWidgets(
          'when the StatefulWidget is removed from tree - scope started by scope() method',
          (WidgetTester tester) async {
        // Create the widget by telling the tester to build it.
        loadKoinModule(testModule2);

        final scopeWidget = UseScopeWidget();
        await tester.pumpWidget(MaterialApp(
          home: scopeWidget,
        ));

        expect(fisrtPageFinder, findsOneWidget);

        var scope = KoinContextHandler.get().getScope(scopeWidget.scopeId);

        var bloc = scope.get<Bloc>();

        expect(bloc.isDisposed, false);

        await tester.tap(gestureFinder);
        await tester.pumpAndSettle();

        expect(bloc.isDisposed, true);

        expect(secondPageFinder, findsOneWidget);
      });
    });

    testWidgets(
        'when the StatefulWidget is removed from tree - scope started by currentScope() extension',
        (WidgetTester tester) async {
      // Create the widget by telling the tester to build it.
      loadKoinModule(testModule3);

      final scopeWidget = UseScopeExtensionWidget();
      await tester.pumpWidget(MaterialApp(
        home: scopeWidget,
      ));

      expect(fisrtPageFinder, findsOneWidget);

      var scope = KoinContextHandler.get().getScope(scopeWidget.scopeId);

      var bloc = scope.get<Bloc>();

      expect(bloc.isDisposed, false);

      await tester.tap(gestureFinder);
      await tester.pumpAndSettle();

      expect(bloc.isDisposed, true);

      expect(secondPageFinder, findsOneWidget);
    });
  });
}
