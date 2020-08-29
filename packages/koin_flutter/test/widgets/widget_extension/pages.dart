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
    componentSingle = getWithParam<Component, int>(1);
    lazyComponent = inject<Component>();
    // TODO
    /*
    componentBSingle = bindWithParams<ComponentBInterface, ComponentB>(
        parameters: parametersOf([10]));
*/
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
      componentFactory:
          getWithParam<Component, int>(60, qualifier: named("Fac")),
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
    final comp =
        getWithParam<Component, int>(60, qualifier: named('Fac')).id.toString();
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text("${bind<ComponentInterface, Component>().testId().toString()}"),
          Text("${inject<Component>().value.id.toString()}"),
          Text("${get<Component>().id.toString()}"),
          Text(comp),
        ],
      ),
    );
  }
}
