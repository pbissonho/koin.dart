import 'package:flutter/material.dart';
import 'package:koin/koin.dart';
import 'package:koin_flutter/koin_flutter.dart';

abstract class ComponentInterface {
  int testId();
}

abstract class ComponentBInterface {
  int testId();
}

class Component implements ComponentInterface {
  Component(this.id);
  final int id;

  @override
  int testId() => id;
}

class ComponentB implements ComponentBInterface {
  ComponentB(this.id);
  final int id;

  @override
  int testId() => id;
}

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
  late Component componentSingle;
  late ComponentBInterface componentBSingle;
  late Component componentScoped;
  late Component componentFactory;

  @override
  void initState() {
    componentSingle = getWithParam<Component, int>(1);
    componentBSingle = bindWithParam<ComponentBInterface, ComponentB, int>(10);
    componentScoped = currentScope.getWithParam<Component, int>(30);
    componentFactory =
        getWithParam<Component, int>(60, qualifier: named("Fac"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text("${componentSingle.id.toString()}"),
          // TODO
          // Text("${componentBSingle.id.toString()}"),
          Text("${componentScoped.id.toString()}"),
          Text("${componentFactory.id.toString()}"),
        ],
      ),
    );
  }
}

class _HomePageState extends State<HomePage> with ScopeStateMixin {
  late Component component;
  late ComponentInterface componentBind;
  late Component componentScoped;
  late Component componentFactory;

  @override
  void initState() {
    componentBind = bind<ComponentInterface, Component>();
    component = get<Component>();
    componentScoped = currentScope.get<Component>();
    componentFactory =
        getWithParam<Component, int>(60, qualifier: named("Fac"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text("${componentBind.testId().toString()}"),
          Text("${component.id.toString()}"),
          Text("${componentScoped.id.toString()}"),
          Text("${componentFactory.id.toString()}"),
        ],
      ),
    );
  }
}

final module3 = Module()
  ..single((s) => Component(20)).bind<ComponentInterface>()
  ..factoryWithParam<Component, int>((s, id) => Component(id),
      qualifier: named("Fac"))
  ..scope<HomePage3>((s) {
    s.scoped((s) => Component(50));
  });

class HomePage3 extends StatefulWidget {
  @override
  _HomePageState3 createState() => _HomePageState3();
}

class _HomePageState3 extends State<HomePage3> {
  late Component component;
  late ComponentInterface componentBind;
  late Component componentScoped;
  late Component componentFactory;

  @override
  void initState() {
    component = get<Component>();
    componentBind = bind<ComponentInterface, Component>();
    componentScoped = scopeContext.get<Component>();
    componentFactory =
        getWithParam<Component, int>(60, qualifier: named("Fac"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text("${componentBind.testId().toString()}"),
          Text("${component.id.toString()}"),
          Text("${componentScoped.id.toString()}"),
          Text("${componentFactory.id.toString()}"),
        ],
      ),
    );
  }
}

final momePageStatelessModule = Module()
  ..single((s) => Component(20)).bind<ComponentInterface>()
  ..factoryWithParam<Component, int>((s, id) => Component(id),
      qualifier: named("Fac"));

class HomePageStateless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final getWithParamResult =
        getWithParam<Component, int>(60, qualifier: named('Fac')).id.toString();
    final bindResult =
        bind<ComponentInterface, Component>().testId().toString();
    final getResult = get<Component>().id.toString();

    return Scaffold(
      body: Column(
        children: <Widget>[
          Text("$getWithParamResult"),
          Text("$bindResult"),
          Text(getResult),
        ],
      ),
    );
  }
}
