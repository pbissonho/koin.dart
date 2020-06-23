import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koin/koin.dart';
import 'package:koin_flutter/koin_flutter.dart';

abstract class ComponentInterface {
  int testId();
}

class Component implements ComponentInterface {
  final int id;

  Component(this.id);

  @override
  int testId() => id;
}

var myModule = Module()
  ..single((s) => Component(20)).bind<ComponentInterface>()
  ..factory1<Component, int>((s, id) => Component(id), qualifier: named("Fac"))
  ..scope<HomePage>((s) {
    s.scoped((s) => Component(50));
  });

var myModule2 = Module()
  ..single((s) => Component(20)).bind<ComponentInterface>()
  ..factory1<Component, int>((s, id) => Component(id), qualifier: named("Fac"))
  ..scope<HomePageStateless>((s) {
    s.scoped((s) => Component(50));
  });

var myModule3 = Module()
  ..single((s) => Component(20)).bind<ComponentInterface>()
  ..factory1<Component, int>((s, id) => Component(id), qualifier: named("Fac"))
  ..scope<HomePage3>((s) {
    s.scoped((s) => Component(50));
  });

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Component component;
  ComponentInterface componentBind;
  Lazy<Component> lazyComponent;
  Component componentScoped;
  Component componentFactory;

  @override
  void initState() {
    componentBind = bind<ComponentInterface, Component>();
    lazyComponent = inject<Component>();
    component = get<Component>();
    componentScoped = widget.scope.get<Component>();
    componentFactory = get<Component>(named("Fac"), parametersOf([60]));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text("${componentBind.testId().toString()}"),
          Text("${lazyComponent().id.toString()}"),
          Text("${component.id.toString()}"),
          Text("${componentScoped.id.toString()}"),
          Text("${componentFactory.id.toString()}"),
        ],
      ),
    );
  }
}

class HomePage3 extends StatefulWidget {
  @override
  _HomePageState3 createState() => _HomePageState3(
      component: get<Component>(),
      componentBind: bind<ComponentInterface, Component>(),
      componentScoped: scope.get<Component>(),
      componentFactory: get<Component>(named("Fac"), parametersOf([60])),
      lazyComponent: inject<Component>());
}

class _HomePageState3 extends State<HomePage3> {
  final Component component;
  final ComponentInterface componentBind;
  final Lazy<Component> lazyComponent;
  final Component componentScoped;
  final Component componentFactory;

  _HomePageState3(
      {this.component,
      this.componentBind,
      this.lazyComponent,
      this.componentScoped,
      this.componentFactory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text("${componentBind.testId().toString()}"),
          Text("${lazyComponent().id.toString()}"),
          Text("${component.id.toString()}"),
          Text("${componentScoped.id.toString()}"),
          Text("${componentFactory.id.toString()}"),
        ],
      ),
    );
  }
}

class HomePageStateless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text("${bind<ComponentInterface, Component>().testId().toString()}"),
          Text("${inject<Component>().value.id.toString()}"),
          Text("${get<Component>().id.toString()}"),
          Text("${scope.get<Component>().id.toString()}"),
          Text("${get<Component>(named('Fac'), parametersOf([
                60
              ])).id.toString()}"),
        ],
      ),
    );
  }
}

void main() {
  tearDown(() {
    stopKoin();
  });

  testWidgets('can get with State extension', (WidgetTester tester) async {
    startKoin((app) {
      app.module(myModule);
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
      app.module(myModule2);
    });

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePageStateless(),
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

  testWidgets('can get with StatefulWidget extension',
      (WidgetTester tester) async {
    startKoin((app) {
      app.module(myModule3);
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
}
