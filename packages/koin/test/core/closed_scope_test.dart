import 'package:koin/koin.dart';
import 'package:koin/src/koin_application.dart';
import 'package:test/test.dart';

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

void main() {
  var scopeName = "MY_SCOPE";
  test("get definition from current scopes type", () {
    var koin = KoinApplication()
        .printLogger()
        .module(Module()
          ..scope(named<ScopeType>(), (scope) {
            scope.scoped((s, p) => ComponentA());
          }))
        .koin;
    var scope1 = koin.createScope("scope1", named<ScopeType>());
    var scope2 = koin.createScope("scope2", named<ScopeType>());

    expect(scope1.get<ComponentA>(), isNot(equals(scope2.get<ComponentA>())));
  });
  test("get definition from current scopes type - with diferente Components",
      () {
    var koin = KoinApplication()
        .printLogger()
        .module(Module()
          ..scope(named<ScopeType>(), (scope) {
            scope.scoped((s, p) => ComponentA());
            scope.scoped((s, p) => ComponentB(s.get()));
          }))
        .koin;
    var scope = koin.createScope("myScope", named<ScopeType>());

    expect(scope.get<ComponentB>(), scope.get<ComponentB>());
    expect(scope.get<ComponentA>(), scope.get<ComponentB>().a);
  });

  test("get definition from current factory scope type", () {
    var koin = KoinApplication()
        .printLogger()
        .module(Module()
          ..scope(named<ScopeType>(), (scope) {
            scope.scoped((s, p) => ComponentA());
            scope.factory((s, p) => ComponentB(s.get()));
          }))
        .koin;
    var scope = koin.createScope("myScope", named<ScopeType>());

    expect(scope.get<ComponentB>(), isNot(equals(scope.get<ComponentB>())));
    expect(scope.get<ComponentA>(), scope.get<ComponentB>().a);
  });

  test(
      "get definition from current factory scope type - With component out of scope. ",
      () {
    var koin = KoinApplication()
        .printLogger()
        .module(Module()
          ..single((s, p) => ComponentA())
          ..scope(named<ScopeType>(), (scope) {
            scope.factory((s, p) => ComponentB(s.get()));
          }))
        .koin;
    var scope = koin.createScope("myScope", named<ScopeType>());

    expect(scope.get<ComponentB>(), isNot(equals(scope.get<ComponentB>())));
    expect(scope.get<ComponentA>(), scope.get<ComponentB>().a);
  });
  test("get definition from current scope type - dispatched modules ", () {
    var koin = KoinApplication().printLogger().modules([
      Module()..scope(named<ScopeType>(), (scope) => scope),
      Module()
        ..scope(named<ScopeType>(),
            (scope) => scope.scoped((s, p) => ComponentA())),
      Module()
        ..scope(named<ScopeType>(),
            (scope) => scope.scoped((s, p) => ComponentB(s.get())))
    ]).koin;

    var scope = koin.createScope("myScope", named<ScopeType>());

    expect(scope.get<ComponentB>(), scope.get<ComponentB>());
    expect(scope.get<ComponentA>(), scope.get<ComponentB>().a);
  });

  test("get definition from current scopes type - with named string qualifier",
      () {
    var koin = KoinApplication()
        .printLogger()
        .module(Module()
          ..scope(named(scopeName), (scope) {
            scope.scoped((s, p) => ComponentA());
          }))
        .koin;
    var scope1 = koin.createScope("scope1", named(scopeName));
    var scope2 = koin.createScope("scope2", named(scopeName));

    expect(scope1.get<ComponentA>(), isNot(equals(scope2.get<ComponentA>())));
  });

  test("get definition from current scopes type - with named string qualifier",
      () {
    var koin = KoinApplication()
        .printLogger()
        .module(Module()
          ..scope(named(scopeName), (scope) {
            scope.scoped((s, p) => ComponentA());
            scope.scoped((s, p) => ComponentB(s.get()));
          }))
        .koin;
    var scope = koin.createScope("myScope", named(scopeName));

    expect(scope.get<ComponentB>(), scope.get<ComponentB>());
    expect(scope.get<ComponentA>(), scope.get<ComponentB>().a);
  });
  test("get definition from outside single", () {
    var koin = KoinApplication()
        .printLogger()
        .module(Module()
          ..single((s, p) => ComponentA())
          ..scope(named(scopeName), (scope) {
            scope.scoped((s, p) => ComponentB(s.get()));
          }))
        .koin;
    var scope = koin.createScope("myScope", named(scopeName));

    expect(scope.get<ComponentB>(), scope.get<ComponentB>());
    expect(scope.get<ComponentA>(), scope.get<ComponentB>().a);
  });
  test("get definition from outside factory", () {
    var koin = KoinApplication()
        .printLogger()
        .module(Module()
          ..factory((s, p) => ComponentA())
          ..scope(named(scopeName), (scope) {
            scope.scoped((s, p) => ComponentB(s.get()));
          }))
        .koin;
    var scope = koin.createScope("myScope", named(scopeName));

    expect(scope.get<ComponentB>(), scope.get<ComponentB>());
    expect(scope.get<ComponentA>(), isNot(equals(scope.get<ComponentB>().a)));
  });

  test("bad mix definition from a scope", () {
    var koin = KoinApplication()
        .printLogger()
        .module(Module()
          ..scope(named(scopeName), (scope) {
            scope.scoped((s, p) => ComponentB(s.get()));
          }))
        .koin;
    var scope = koin.createScope("myScope", named(scopeName));

    try {
      scope.get<ComponentA>();
      fail("message");
    } catch (error) {
      print(error.toString());
    }
  });

  test("mix definition from a scope", () {
    var koin = KoinApplication()
        .printLogger()
        .module(Module()
          ..scope(named("SCOPE_1"), (scope) {
            scope.scoped((s, p) => ComponentA());
          })
          ..scope(named("SCOPE_2"), (scope) {
            scope.scoped((s, p) {
              var scope = p.getWhere<Scope>() as Scope;
              return ComponentB(scope.get());
            });
          }))
        .koin;
    var scope1 = koin.createScope("myScope1", named("SCOPE_1"));
    var scope2 = koin.createScope("myScope2", named("SCOPE_2"));
    var b = scope2.get<ComponentB>(null, parametersOf([scope1]));
    var a = scope1.get<ComponentA>();

    expect(a, b.a);
  });

  test("definition params for scoped definitions", () {
    var koin = KoinApplication()
        .printLogger()
        .module(Module()
          ..scope(named("SCOPE_1"), (scope) {
            scope.scoped((s, p) => MySingle(p.getWhere<int>()));
          }))
        .koin;

    var scope1 = koin.createScope("myScope1", named("SCOPE_1"));
    var parameters = 42;
    var a = scope1.get<MySingle>(null, parametersOf([42]));
    expect(parameters, a.value);
  });
}
