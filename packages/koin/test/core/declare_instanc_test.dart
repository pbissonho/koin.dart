import 'package:koin/koin.dart';
import 'package:koin/src/core/error/exceptions.dart';
import 'package:koin/src/koin_application.dart';
import 'package:test/test.dart';

import '../classes.dart';

void main() {
  test("can declare a single on the fly", () {
    var koin = KoinApplication().printLogger().koin;

    var a = ComponentA();

    koin.declare(a);
  });
  test("not can declare a single on the fly", () {
    var koin = KoinApplication()
        .printLogger()
        .module(module()..single((s, p) => ComponentA()))
        .koin;

    var a = ComponentA();

    expect(() => koin.declare(a), throwsA(isA<DefinitionOverrideException>()));
  });

  test("can declare and override a single on the fly", () {
    var koin = KoinApplication()
        .printLogger()
        .module(module()..single((s, p) => MySingle(1)))
        .koin;

    var a = MySingle(2);

    koin.declare(a, override: true);
    expect(2, koin.get<MySingle>().value);
  });

  test(
      "not can declare and override a single on the fly when override is set to false",
      () {
    var koin = KoinApplication()
        .printLogger()
        .module(module()..single((s, p) => MySingle(1)))
        .koin;

    var a = MySingle(2);

    try {
      koin.declare(a, override: false);
      fail("shoud trow a exception");
    } catch (error) {
      print(error.toString());
    }

    expect(1, koin.get<MySingle>().value);
  });

  test("can declare a single with qualifier on the fly", () {
    var koin = KoinApplication()
        .printLogger()
        .module(module()..single((s, p) => ComponentA()))
        .koin;

    var a = ComponentImpl();
    koin.declare<ComponentA>(a, qualifier: named("another_a"));

    // TODO
    // When get named data without pass a Type, the type is passed ay dynamic and the Definition is configured as dynamic
    var getA = koin.get(named("another_a"));
    expect(a, getA);
    expect(a, isNot(equals(koin.get<ComponentA>())));
  });

  test("can declare and override a single with qualifier on the fly", () {
    var koin = KoinApplication()
        .printLogger()
        .module(module()
          ..single((s, p) => ComponentA())
          ..single((s, p) => ComponentA(), qualifier: named("another_a")))
        .koin;

    var a = ComponentImpl();
    koin.declare(a, qualifier: named("another_a"), override: true);

    // TODO
    // When get named data without pass a Type, the type is passed ay dynamic and the Definition is configured as dynamic
    var getA = koin.get(named("another_a"));
    expect(a, getA);
    expect(a, isNot(equals(koin.get<ComponentA>())));
  });

  test("can declare a single with secondary type on the fly", () {
    var koin = KoinApplication()
        .printLogger()
        .module(module()..single((s, p) => ComponentA()))
        .koin;

    var a = Component1();
    koin.declare<Component1>(a, secondaryTypes: [ComponentInterface1]);

    expect(a, koin.get<Component1>());
    expect(a, koin.get<ComponentInterface1>());
  });

  test("can declare and override a single with secondary type on the fly", () {
    var koin = KoinApplication()
        .printLogger()
        .module(module()..single((s, p) => ComponentA()))
        .koin;

    var a = Component1();
    var b = Component1();

    koin.declare(a, secondaryTypes: [ComponentInterface1]);
    koin.declare(b, secondaryTypes: [ComponentInterface1], override: true);

    expect(b, koin.get<Component1>());
    expect(b, koin.get<ComponentInterface1>());
  });

  test("can declare a scoped on the fly", () {
    var koin = KoinApplication()
        .printLogger()
        .module(module()
          ..scope(named("Session"), (scope) {
            scope.scoped((s, p) => ComponentB(s.get()));
          }))
        .koin;

    var a = ComponentA();

    var session1 = koin.createScope("session1", named("Session"));
    session1.declare(a);

    expect(a, session1.get<ComponentA>());
    expect(a, session1.get<ComponentB>().a);
  });

  test("can't declare a scoped-single on the fly", () {
    var koin = KoinApplication()
        .printLogger()
        .module(module()..scope(named("Session"), (scope) {}))
        .koin;

    var a = ComponentA();

    var session1 = koin.createScope("session1", named("Session"));
    session1.declare(a);

    expect(
        () => koin.get<ComponentA>(), throwsA(isA<NoBeanDefFoundException>()));
  });

  test("can't declare a other scoped on the fly", () {
    var koin = KoinApplication()
        .printLogger()
        .module(module()..scope(named("Session"), (scope) {}))
        .koin;

    var a = ComponentA();

    var session1 = koin.createScope("session1", named("Session"));
    var session2 = koin.createScope("session2", named("Session"));

    session1.declare(a);

    expect(() => session2.get<ComponentA>(),
        throwsA(isA<NoBeanDefFoundException>()));
  });
}
