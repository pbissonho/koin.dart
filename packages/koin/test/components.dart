class Simple {}

class ComponentA {}

class ComponentB {
  final ComponentA a;

  ComponentB(this.a);
}

class ComponentC {
  final ComponentB b;

  ComponentC(this.b);
}

abstract class ComponentInterface1 {}

abstract class ComponentInterface2 {}

class Component1 implements ComponentInterface1, ComponentInterface2 {}

class Component2 implements ComponentInterface1 {}

class UserComponent {
  final ComponentInterface1 c1;

  UserComponent(this.c1);
}

class MySingle {
  final int id;

  MySingle(this.id);
}

class MyIntFactory {
  final int id;

  MyIntFactory(this.id);
}

class MyStringFactory {
  final String s;

  MyStringFactory(this.s);
}

class AllFactory {
  final MyIntFactory myIntFactory;
  final MyStringFactory myStringFactory;

  AllFactory(this.myIntFactory, this.myStringFactory);
}
