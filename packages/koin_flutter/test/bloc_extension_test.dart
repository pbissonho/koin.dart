import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koin/koin.dart';
import 'package:koin_test/koin_test.dart';
import 'package:koin/internal.dart';
import 'package:koin/instance_scope_ext.dart';

import 'widgets/bloc_extension/modules.dart';
import 'widgets/bloc_extension/pages.dart';

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
        '''the scope should not be created - when scope() or currentScope()
         is not called''', (tester) async {
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
        '''shoud not create a scope for the StatefulWidget - when the scope() or currentScope() not is called at least once''',
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
          '''when the StatefulWidget is removed from tree - scope started by currentScope() method''',
          (tester) async {
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
          '''when the StatefulWidget is removed from tree - scope started by scope()
           method''', (tester) async {
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
        '''when the StatefulWidget is removed from tree - scope started by currentScope()
         extension''', (tester) async {
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
