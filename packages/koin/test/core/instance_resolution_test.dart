import 'package:koin/koin.dart';
import 'package:test/test.dart';

import '../components.dart';

void main() {
  test('can resolve a single', () {
    var koin = koinApplication((app) {
      app.module(module()..single((s) => ComponentA()));
    }).koin;

    var a = koin.get<ComponentA>();
    var a2 = koin.get<ComponentA>();

    expect(a, a2);
  });

  test('can resolve all ComponentInterface1', () {
    var koin = koinApplication((app) {
      app.module(module()
        ..single((s) => Component1()).bind<ComponentInterface1>()
        ..single((s) => Component2()).bind<ComponentInterface1>());
    }).koin;

    var a = koin.get<Component1>();
    var a2 = koin.get<Component2>();

    var instances = koin.getAll<ComponentInterface1>();

    expect(
        instances.length == 2 &&
            instances.contains(a) &&
            instances.contains(a2),
        true);
  });

  test('cannot resolve a single', () {
    var koin = koinApplication((app) {
      app.module(module());
    }).koin;

    var a = koin.getOrNull<ComponentA>(null, null);
    expect(a, null);
  });

  test('can lazy resolve a single by name', () {
    var component = ComponentA();

    var koin = koinApplication((app) {
      app.module(module()
        ..single((s) => component, qualifier: named('A'))
        ..single((s) => component, qualifier: named('B')));
    }).koin;

    var a = koin.get<ComponentA>(named('A'));
    var b = koin.get<ComponentA>(named('B'));

    expect(a, b);
  });

  test('can resolve a factory by name', () {
    var component = ComponentA();

    var koin = koinApplication((app) {
      app.module(module()
        ..factory((s) => component, qualifier: named('A'))
        ..factory((s) => component, qualifier: named('B')));
    }).koin;

    var a = koin.get<ComponentA>(named('A'));
    var b = koin.get<ComponentA>(named('B'));

    expect(a, b);
  });

  test('can resolve a factory', () {
    var koin = koinApplication((app) {
      app.module(module()..factory((s) => ComponentA()));
    }).koin;

    var a = koin.get<ComponentA>();
    var b = koin.get<ComponentA>();

    expect(a, isNot(b));
    expect(a != b, true);
  });

  test('should resolve default', () {
    var koin = koinApplication((app) {
      app.module(module()
        ..single<ComponentInterface1>((s) => Component2(),
            qualifier: named('2'))
        ..single<ComponentInterface1>(
          (s) => Component1(),
        ));
    }).koin;

    var component = koin.get<ComponentInterface1>();

    expect(component, isA<Component1>());
    expect(koin.get<ComponentInterface1>(named('2')), isA<Component2>());
  });

  // TODO
  /* 
  test('can resolve a single with type', () {
    var koin = koinApplication((app) {
      app.module(module()..single((s) => ComponentA()));
    }).koin;

    var a = koin.getWithType(ComponentA);
    var a2 = koin.getWithType(ComponentA);

    expect(a, a2);
  });

  test('can resolve a single with type or null', () {
    var koin = koinApplication((app) {
      app.module(module()..single((s) => ComponentA()));
    }).koin;

    var a = koin.getOrNullWithType(ComponentA);
    var a2 = koin.getOrNullWithType(ComponentA);
    var a3 = koin.getOrNullWithType(ComponentB);

    expect(a, a2);
    expect(a3, isNull);
  });

  test('can resolve a single with type or null', () {
    var koin = koinApplication((app) {
      app.module(module()..single((s) => ComponentA()));
    }).koin;

    var a = koin.getOrNullWithType(ComponentA);
    var a2 = koin.getOrNullWithType(ComponentA);
    var a3 = koin.getOrNullWithType(ComponentB);

    expect(a, a2);
    expect(a3, isNull);
  });*/
}
