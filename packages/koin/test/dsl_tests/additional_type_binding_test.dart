import 'package:koin/koin.dart';
import 'package:test/test.dart';

import '../components.dart';

import '../extensions/koin_application_ext.dart';

void main() {
  test('can resolve an additional type bind', () {
    var app = koinApplication((app) {
      app.printLogger();
      app.module(
          module()..single((s) => Component1()).bind<ComponentInterface1>());
    });

    app.expectDefinitionsCount(1);

    var koin = app.koin;
    var c1 = koin.get<Component1>();
    var c = koin.get<ComponentInterface1>();

    expect(c1, equals(c));
  });

  test('can resolve an additional type - bind()', () {
    var app = koinApplication((app) {
      app.printLogger();
      app.module(
          module()..single((s) => Component1()).bind<ComponentInterface1>());
    });

    app.expectDefinitionsCount(1);

    var koin = app.koin;
    var c1 = koin.get<Component1>();
    var c = koin.bind<ComponentInterface1, Component1>();

    expect(c1, equals(c));
  });

  test('can resolve an additional type', () {
    var app = koinApplication((app) {
      app.printLogger();
      app.module(
          module()..single((s) => Component1()).bind<ComponentInterface1>());
    });

    app.expectDefinitionsCount(1);

    var koin = app.koin;
    var c1 = koin.get<Component1>();
    var c = koin.get<ComponentInterface1>();

    expect(c1, equals(c));
  });

  test('resolve first additional type', () {
    var app = koinApplication((app) {
      app.printLogger();
      app.module(module()
        ..single((s) => Component1()).bind<ComponentInterface1>()
        ..single((s) => Component2()).bind<ComponentInterface1>());
    });

    app.expectDefinitionsCount(2);

    var koin = app.koin;
    koin.get<ComponentInterface1>();

    expect(koin.bind<ComponentInterface1, Component1>(),
        isNot(koin.bind<ComponentInterface1, Component2>()));
  });

  test('can resolve an additional type in DSL', () {
    var app = koinApplication((app) {
      app.printLogger();
      app.module(module()
        ..single((s) => Component1()).bind<ComponentInterface1>()
        ..single((s) => Component2()).bind<ComponentInterface1>()
        ..single(
            (s) => UserComponent(s.bind<ComponentInterface1, Component1>())));
    });

    app.expectDefinitionsCount(3);

    var koin = app.koin;
    koin.get<ComponentInterface1>();

    expect(koin.get<UserComponent>().c1, koin.get<Component1>());
  });

  test('additional type conflict - error', () {
    koinApplication((app) {
      app.printLogger();
      app.module(module()
        ..single((s) => Component2()).bind<ComponentInterface1>()
        ..single<ComponentInterface1>((s) => Component1()));
    });
  });

  test('should not conflict name & default type', () {
    var app = koinApplication((app) {
      app.printLogger();
      app.module(module()
        ..single<ComponentInterface1>((s) => Component2(),
            qualifier: named('default'))
        ..single<ComponentInterface1>((s) => Component1()));
    });

    app.expectDefinitionsCount(2);

    var koin = app.koin;

    var c1 = koin.get<ComponentInterface1>();
    var defaultC1 = koin.get<ComponentInterface1>(named('default'));

    expect(c1, isNot(defaultC1));
  });

  test('can resolve an additional types', () {
    var app = koinApplication((app) {
      app.printLogger();
      app.module(module()
        ..single((s) => Component1())
            .binds([ComponentInterface1, ComponentInterface2]));
    });

    app.expectDefinitionsCount(1);

    var koin = app.koin;
    var c1 = koin.get<Component1>();
    var ci1 = koin.bind<ComponentInterface1, Component1>();
    var ci2 = koin.bind<ComponentInterface2, Component1>();

    expect(c1, ci1);
    expect(c1, ci2);
  });

  test('additional type conflict', () {
    var koin = koinApplication((app) {
      app.printLogger();
      app.module(module()
        ..single<ComponentInterface1>((s) => Component1())
        ..single((s) => Component2()).bind<ComponentInterface1>());
    }).koin;

    expect(koin.getAll<ComponentInterface1>().length, 2);
    expect(koin.get<ComponentInterface1>().runtimeType, Component1);
  }, skip: true);

  test('conflicting with additional types', () {
    var koin = koinApplication((app) {
      app.printLogger();
      app.module(module()
        ..single<ComponentInterface1>((s) => Component2())
        ..single((s) => Component1())
            .binds([ComponentInterface1, ComponentInterface2]));
    }).koin;

    expect(koin.getAll<ComponentInterface1>().length, 2);
  }, skip: true);
}
