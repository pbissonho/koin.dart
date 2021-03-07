import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koin/koin.dart';
import 'widgets/widget_extension/modules.dart';
import 'widgets/widget_extension/pages.dart';

void main() {
  tearDown(stopKoin);

  testWidgets('can get with State extension', (tester) async {
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
    final componentIdFactoryFinder = find.text('60');

    expect(componentIdFinder, findsNWidgets(2));
    expect(componentScopedIdFinder, findsOneWidget);
    expect(componentIdFactoryFinder, findsOneWidget);
  });

  testWidgets('can get with StatelessWidget extension -', (tester) async {
    startKoin((app) {
      app.module(momePageStatelessModule);
    });

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePageStateless(),
    ));

    // Create the Finders.
    final componentIdFinder = find.text('20');

    // Create the Finders.
    final componentIdFinder60 = find.text('60');
    expect(componentIdFinder, findsNWidgets(2));
    expect(componentIdFinder60, findsOneWidget);
  });

  testWidgets('can get with StatefulWidget extension', (tester) async {
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

    expect(componentIdFinder, findsNWidgets(2));
    expect(componentScopedIdFinder, findsOneWidget);
    expect(componentIdFactoryFinder, findsOneWidget);
  });

  testWidgets('can get with StatefulWidget extension - withParam',
      (tester) async {
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
    final componentBSingleFinder = find.text('10');
    final componentIdFactoryFinder = find.text('60');
    final componentScopedFinder = find.text('30');

    expect(componentSingleIdFinder, findsNWidgets(1));
    expect(componentBSingleFinder, findsOneWidget);
    expect(componentIdFactoryFinder, findsOneWidget);
    expect(componentScopedFinder, findsOneWidget);
  });
}
