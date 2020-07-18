import 'package:koin/koin.dart';
import 'package:koin/src/core/error/exceptions.dart';
import 'package:test/test.dart';

import '../components.dart';

void main() {
  test('can declare a single on the fly', () {
    var koin = koinApplication((app) {
      app.printLogger();
    }).koin;

    var a = ComponentA();

    koin.declare(a);
  });
  test('not can declare a single on the fly', () {
    var koin = KoinApplication()
        .printLogger()
        .module(module()..single((s) => ComponentA()))
        .koin;

    var a = ComponentA();

    expect(() => koin.declare(a), throwsA(isA<DefinitionOverrideException>()));
  });

  test('can declare and override a single on the fly', () {
    var koin = KoinApplication()
        .printLogger()
        .module(module()..single((s) => MySingle(1)))
        .koin;

    var a = MySingle(2);

    koin.declare(a, override: true);
    expect(2, koin.get<MySingle>().id);
  });

  test("""
Not can declare and override a single on the fly when override is set to false""",
      () {
    var koin = KoinApplication()
        .printLogger()
        .module(module()..single((s) => MySingle(1)))
        .koin;

    var a = MySingle(2);

    try {
      koin.declare(a, override: false);
      fail('shoud trow a exception');
    } catch (error) {
      print(error.toString());
    }

    expect(1, koin.get<MySingle>().id);
  });

  test('can declare a single with qualifier on the fly', () {
    var koin = KoinApplication()
        .printLogger()
        .module(module()..single<ComponentA>((s) => ComponentA()))
        .koin;

    var a = ComponentA();
    koin.declare(a, qualifier: named('another_a'));

    // TODO
    // When get named data without pass a Type, the type i
    // s passed ay dynamic and the Definition is configured as dynamic
    var getA = koin.get<ComponentA>(named('another_a'));
    expect(a, getA);
    expect(a, isNot(equals(koin.get<ComponentA>())));
  });

  test('can declare and override a single with qualifier on the fly', () {
    var koin = KoinApplication()
        .printLogger()
        .module(module()
          ..single((s) => ComponentA())
          ..single((s) => ComponentA(), qualifier: named('another_a')))
        .koin;

    var a = ComponentA();
    koin.declare(a, qualifier: named('another_a'), override: true);

    var getA = koin.get<ComponentA>(named('another_a'));
    expect(a, getA);
    expect(a, isNot(equals(koin.get<ComponentA>())));
  });

  test('can declare a single with secondary type on the fly', () {
    var koin = KoinApplication()
        .printLogger()
        .module(module()..single((s) => ComponentA()))
        .koin;

    var a = Component1();
    koin.declare<Component1>(a, secondaryTypes: [ComponentInterface1]);

    expect(a, koin.get<Component1>());
    expect(a, koin.get<ComponentInterface1>());
  });

  test('can declare and override a single with secondary type on the fly', () {
    var koin = KoinApplication()
        .printLogger()
        .module(module()..single((s) => ComponentA()))
        .koin;

    var a = Component1();
    var b = Component1();

    koin.declare(a, secondaryTypes: [ComponentInterface1]);
    koin.declare(b, secondaryTypes: [ComponentInterface1], override: true);

    expect(b, koin.get<Component1>());
    expect(b, koin.get<ComponentInterface1>());
  });

  test('can declare a scoped on the fly', () {
    var koin = KoinApplication()
        .printLogger()
        .module(module()
          ..scopeWithType(named('Session'), (scope) {
            scope.scoped((s) => ComponentB(s.get()));
          }))
        .koin;

    var a = ComponentA();

    var session1 = koin.createScopeWithQualifier('session1', named('Session'));
    session1.declare(a);

    expect(a, session1.get<ComponentA>());
    expect(a, session1.get<ComponentB>().a);
  });

  test("can't declare a scoped-single on the fly", () {
    var koin = KoinApplication()
        .printLogger()
        .module(module()..scopeWithType(named('Session'), (scope) {}))
        .koin;

    var a = ComponentA();

    var session1 = koin.createScopeWithQualifier('session1', named('Session'));
    session1.declare(a);

    expect(
        () => koin.get<ComponentA>(), throwsA(isA<NoBeanDefFoundException>()));
  });

  test("can't declare a other scoped on the fly", () {
    var koin = KoinApplication()
        .printLogger()
        .module(module()..scopeWithType(named('Session'), (scope) {}))
        .koin;

    var a = ComponentA();

    var session1 = koin.createScopeWithQualifier('session1', named('Session'));
    var session2 = koin.createScopeWithQualifier('session2', named('Session'));

    session1.declare(a);

    expect(() => session2.get<ComponentA>(),
        throwsA(isA<NoBeanDefFoundException>()));
  });
}
