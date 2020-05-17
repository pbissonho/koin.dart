import 'package:koin/koin.dart';
import 'package:koin/src/core/context/context_functions.dart';
import 'package:koin/src/core/context/koin_context_handler.dart';
import 'package:koin/src/dsl/koin_application_dsl.dart';
import 'package:test/test.dart';

import '../components.dart';
import '../extensions/koin_application_ext.dart';

void main() {
  test('can isolate several koin apps', () {
    var app1 = koinApplication((app) {
      app.module(module()..single((s, p) => ComponentA()));
    });

    var app2 = koinApplication((app) {
      app.module(module()..single((s, p) => ComponentA()));
    });

    var a1 = app1.koin.get<ComponentA>();
    var a2 = app2.koin.get<ComponentA>();

    expect(a1, isNot(a2));
  });

  test('can isolate several koin apps', () {
    var app = koinApplication((app) {
      app.module(module(createdAtStart: true)..single((s, p) => ComponentA()));
    });

    app.createEagerInstances();

    app.getBeanDefinition(ComponentA);

    expect(
        app.koin.scopeRegistry.rootScope.instanceRegistry.instances.values
            .first(
                (factory) => factory.beanDefinition.primaryType == ComponentA)
            .isCreated(),
        true);
  });

  test('can isolate koin apps e standalone', () {
    startKoin2((app) {
      app.module(module()..single((s, p) => ComponentA()));
    });

    var app2 = koinApplication((app) {
      app.module(module()..single((s, p) => ComponentA()));
    });

    var a1 = KoinContextHandler.get().get<ComponentA>();
    var a2 = app2.koin.get<ComponentA>();

    expect(a1, isNot(a2));
    stopKoin();
  });

  test('stopping koin releases resources', () {
    var module = Module()
      ..single<ComponentA>((s, p) => ComponentA())
      ..scope<Simple>((dsl) {
        dsl.scoped((s, p) => ComponentB(s.get()));
      });

    startKoin2((app) {
      app.module(module);
    });

    var a1 = KoinContextHandler.get().get<ComponentA>();
    var scope1 =
        KoinContextHandler.get().createScope('simple', named<Simple>());
    var b1 = scope1.get<ComponentB>();

    stopKoin();

    startKoin2((app) {
      app.module(module);
    });

    var a2 = KoinContextHandler.get().get<ComponentA>();
    var scope2 =
        KoinContextHandler.get().createScope('simple', named<Simple>());
    var b2 = scope2.get<ComponentB>();

    expect(a1, isNot(a2));
    expect(b1, isNot(b2));

    stopKoin();
  });

  test('create multiple context without named qualifier', () {
    var koinA = koinApplication((app) {
      app.modules([
        Module()..single((s, p) => ModelA()),
        Module()..single((s, p) => ModelB(s.get()))
      ]);
    });

    var koinB = koinApplication((app) {
      app.modules([
        Module()..single((s, p) => ModelC()),
      ]);
    });

    koinA.koin.get<ModelA>();
    koinA.koin.get<ModelB>();
    koinB.koin.get<ModelC>();

    try {
      koinB.koin.get<ModelA>();
      fail('');
    } catch (e) {}
    try {
      koinB.koin.get<ModelB>();
      fail('');
    } catch (e) {}
    try {
      koinA.koin.get<ModelC>();
      fail('');
    } catch (e) {}
  });
}

class ModelA {}

class ModelB {
  final ModelA a;

  ModelB(this.a);
}

class ModelC {}
