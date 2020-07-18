import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koin/koin.dart';
import 'package:koin_flutter/koin_flutter.dart';

abstract class ComponentInterface {
  int testId();
}

abstract class ComponentBInterface {
  int testId();
}

class Component implements ComponentInterface {
  final int id;

  Component(this.id);

  @override
  int testId() => id;
}

class ComponentB implements ComponentBInterface {
  final int id;

  ComponentB(this.id);

  @override
  int testId() => id;
}

var module = Module()
  ..single((s) => Component(20)).bind<ComponentInterface>()
  ..factory1<Component, int>((s, id) => Component(id), qualifier: named("Fac"))
  ..scope<HomePage>((s) {
    s.scoped((s) => Component(50));
  });

var module2 = Module()
  ..single((s) => Component(20)).bind<ComponentInterface>()
  ..factory1<Component, int>((s, id) => Component(id), qualifier: named("Fac"))
  ..scope<HomePageStateless>((s) {
    s.scoped((s) => Component(50));
  });

var module3 = Module()
  ..single((s) => Component(20)).bind<ComponentInterface>()
  ..factory1<Component, int>((s, id) => Component(id), qualifier: named("Fac"))
  ..scope<HomePage3>((s) {
    s.scoped((s) => Component(50));
  });

var moduleWithParams = Module()
  ..single1<Component, int>((s, value) => Component(value))
      .bind<ComponentInterface>()
  ..single1<ComponentB, int>((s, value) => ComponentB(value))
      .bind<ComponentBInterface>()
  ..factory1<Component, int>((s, id) => Component(id), qualifier: named("Fac"))
  ..scope<HomePageWithParams>((s) {
    s.scoped1<Component, int>((s, value) => Component(value));
  });

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class HomePageWithParams extends StatefulWidget {
  @override
  _HomePageWithParamsState createState() => _HomePageWithParamsState();
}

class _HomePageWithParamsState extends State<HomePageWithParams>
    with ScopeStateMixin {
  Component componentSingle;
  ComponentB componentBSingle;
  Lazy<Component> lazyComponent;
  Component componentScoped;
  Component componentFactory;

  @override
  void initState() {
    componentSingle = getWithParams<Component>(parameters: parametersOf([1]));
    lazyComponent = injectWithParams<Component>();

    componentBSingle = bindWithParams<ComponentBInterface, ComponentB>(
        parameters: parametersOf([10]));

    componentScoped =
        currentScope.getWithParams<Component>(parameters: parametersOf([30]));

    componentFactory = getWithParams<Component>(
        qualifier: named("Fac"), parameters: parametersOf([60]));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text("${lazyComponent().id.toString()}"),
          Text("${componentSingle.id.toString()}"),
          Text("${componentBSingle.id.toString()}"),
          Text("${componentScoped.id.toString()}"),
          Text("${componentFactory.id.toString()}"),
        ],
      ),
    );
  }
}

class _HomePageState extends State<HomePage> with ScopeStateMixin {
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
    componentScoped = currentScope.get<Component>();
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
      app.module(module);
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
