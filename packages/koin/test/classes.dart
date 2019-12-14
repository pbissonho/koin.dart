class ScopeType {}

class ComponentA {}

class ComponentB {
  final ComponentA a;

  ComponentB(this.a);
}

class MySingle {
  final int value;

  MySingle(this.value);
}

class ComponentInterface1 {}

class Component1 implements ComponentInterface1 {}
class Component2 implements ComponentInterface1 {}

class ComponentImpl implements ComponentA {}