import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koin/koin.dart';
import 'widgets/widget_extension/pages.dart';
import 'widgets/widget_extension/modules.dart';

void main() {
  tearDown(() {
    stopKoin();
  });

  testWidgets('can get with State extension', (WidgetTester tester) async {
    startKoin((app) {
      app.module(module1);
    });

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    ));

    // Create the Finders.
    final componentIdFinder = find.text('20');
    // Create the Finders.
    final componentScopedIdFinder = find.text('50');
    // Create the Finders.
    final componentIdFactoryFinder = find.text('60');

    // Use the `findsOneWidget` matcher provided by flutter_test to
    // verify that the Text widgets appear exactly once in the widget tree.
    expect(componentIdFinder, findsNWidgets(3));
    expect(componentScopedIdFinder, findsOneWidget);
    expect(componentIdFactoryFinder, findsOneWidget);
  });

  testWidgets('can get with StatelessWidget extension',
      (WidgetTester tester) async {
    startKoin((app) {
      app.module(module2);
    });

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePageStateless(),
    ));

    // Create the Finders.
    final componentIdFinder = find.text('20');
    // Create the Finders.
    final componentIdFactoryFinder = find.text('60');

    // Use the `findsOneWidget` matcher provided by flutter_test to
    // verify that the Text widgets appear exactly once in the widget tree.
    expect(componentIdFinder, findsNWidgets(3));
    expect(componentIdFactoryFinder, findsOneWidget);
  });

  testWidgets('can get with StatefulWidget extension',
      (WidgetTester tester) async {
    startKoin((app) {
      app.module(module3);
    });

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage3(),
    ));

    // Create the Finders.
    final componentIdFinder = find.text('20');
    // Create the Finders.
    final componentScopedIdFinder = find.text('50');
    // Create the Finders.
    final componentIdFactoryFinder = find.text('60');

    // Use the `findsOneWidget` matcher provided by flutter_test to
    // verify that the Text widgets appear exactly once in the widget tree.
    expect(componentIdFinder, findsNWidgets(3));
    expect(componentScopedIdFinder, findsOneWidget);
    expect(componentIdFactoryFinder, findsOneWidget);
  });

  testWidgets('can get with StatefulWidget extension - withParams',
      (WidgetTester tester) async {
    startKoin((app) {
      app.module(moduleWithParams);
    });

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePageWithParams(),
    ));

    // Create the Finders.
    final componentSingleIdFinder = find.text('1');
    // Create the Finders.
    final componentBSingleFinder = find.text('10');
    // Create the Finders.
    final componentIdFactoryFinder = find.text('60');

    // Create the Finders.
    final componentScopedFinder = find.text('30');

    // Use the `findsOneWidget` matcher provided by flutter_test to
    // verify that the Text widgets appear exactly once in the widget tree.
    expect(componentSingleIdFinder, findsNWidgets(2));
    expect(componentBSingleFinder, findsOneWidget);
    expect(componentIdFactoryFinder, findsOneWidget);
    expect(componentScopedFinder, findsOneWidget);
  });

  testWidgets('can get with StatefulWidget extension - withParams',
      (WidgetTester tester) async {
    startKoin((app) {
      app.module(moduleWithParams);
    });

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePageWithParams(),
    ));

    // Create the Finders.
    final componentSingleIdFinder = find.text('1');
    // Create the Finders.
    final componentBSingleFinder = find.text('10');
    // Create the Finders.
    final componentIdFactoryFinder = find.text('60');
    // Create the Finders.
    final componentScopedFinder = find.text('30');

    // Use the `findsOneWidget` matcher provided by flutter_test to
    // verify that the Text widgets appear exactly once in the widget tree.
    expect(componentSingleIdFinder, findsNWidgets(2));
    expect(componentBSingleFinder, findsOneWidget);
    expect(componentIdFactoryFinder, findsOneWidget);
    expect(componentScopedFinder, findsOneWidget);
  });
}
