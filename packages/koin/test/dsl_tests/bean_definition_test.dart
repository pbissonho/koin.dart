import 'package:koin/internals.dart';
import 'package:koin/src/definition/definition.dart';
import 'package:koin/src/koin_application.dart';
import 'package:koin/src/definition/definitions.dart';
import 'package:koin/src/instance/instance_context.dart';
import 'package:koin/src/koin_dart.dart';
import 'package:koin/src/module.dart';
import 'package:koin/src/scope/scope.dart';
import 'package:test/test.dart';

import '../components.dart';

import 'package:koin/src/qualifier.dart';
import 'package:koin/src/definition/provider_definition.dart';

import '../extensions/koin_application_ext.dart';

void main() {
  Koin koin;
  Scope rootScope;

  setUp(() {
    koin = koinApplication((app) {}).koin;
    rootScope = koin.scopeRegistry.rootScope;
  });

  test('equals definitions', () {
    var def1 = Definitions.createSingle(
        providerCreate:
            ProviderCreateDefinition<ComponentA>((s) => ComponentA()),
        scopeDefinition: rootScope.scopeDefinition,
        options: Options());
    var def2 = Definitions.createSingle(
        providerCreate:
            ProviderCreateDefinition<ComponentA>((s) => ComponentA()),
        scopeDefinition: rootScope.scopeDefinition,
        options: Options());

    expect(def1, def2);
  });

  test('scope definition', () {
    var def1 = Definitions.createSingle(
        providerCreate:
            ProviderCreateDefinition<ComponentA>((s) => ComponentA()),
        scopeDefinition: rootScope.scopeDefinition,
        options: Options());

    expect(def1.scopeDefinition, rootScope.scopeDefinition);
    expect(def1.kind, Kind.single);
  });

  test('equals definitions - but diif kind', () {
    var def1 = Definitions.createSingle(
        providerCreate:
            ProviderCreateDefinition<ComponentA>((s) => ComponentA()),
        scopeDefinition: rootScope.scopeDefinition,
        options: Options());
    var def2 = Definitions.createSingle(
        providerCreate:
            ProviderCreateDefinition<ComponentA>((s) => ComponentA()),
        scopeDefinition: rootScope.scopeDefinition,
        options: Options());

    expect(def1, def2);
  });

  test('definition kind', () {
    var app = koinApplication((app) {
      app.module(module()
        ..single<ComponentA>((s) => ComponentA())
        ..factory<ComponentB>((s) => ComponentB(s.get<ComponentA>())));
    });

    var defA = app.getBeanDefinition(ComponentA);
    expect(Kind.single, defA.kind);

    var defB = app.getBeanDefinition(ComponentB);
    expect(Kind.factory, defB.kind);
  });

  test('definition name', () {
    var name = named('A');

    var app = koinApplication((app) {
      app.module(module()
        ..single<ComponentA>((s) => ComponentA(), qualifier: name)
        ..factory<ComponentB>((s) => ComponentB(s.get<ComponentA>())));
    });

    var defA = app.getBeanDefinition(ComponentA);
    expect(name, defA.qualifier);

    var defB = app.getBeanDefinition(ComponentB);
    expect(defB.qualifier, null);
  });

  test('definition function', () {
    var app = koinApplication((app) {
      app.module(module()..single<ComponentA>((s) => ComponentA()));
    });

    app.getBeanDefinition(ComponentA);
    var instance = app.getInstanceFactory(ComponentA).get(InstanceContext(
        koin: app.koin,
        scope: rootScope,
        parameter: emptyParameter()));

    expect(instance, app.koin.get<ComponentA>());
  });

  test('indexKey', () {
    var type = ComponentA;
    var id = indexKey(type, null);

    expect(id, 'ComponentA');
  });
}
