import 'package:koin/extension.dart';
import 'package:koin/internal.dart';
import 'package:koin/src/core/definition/definitions.dart';
import 'package:koin/src/core/instance/instance_context.dart';
import 'package:koin/src/core/koin_dart.dart';
import 'package:koin/src/core/scope/scope.dart';
import 'package:koin/src/dsl/koin_application_dsl.dart';
import 'package:koin/src/dsl/module_dsl.dart';
import 'package:test/test.dart';

import 'package:koin/src/core/definition/options.dart';
import '../components.dart';
import '../extensions/koin_application_ext.dart';

import 'package:koin/src/core/qualifier.dart';
import 'package:koin/src/core/definition/bean_definition.dart';

void main() {
  Koin koin;
  Scope rootScope;

  setUp(() {
    koin = koinApplication((app) {}).koin;
    rootScope = koin.scopeRegistry.rootScope;
  });

  test('equals definitions', () {
    var def1 = Definitions.createSingle(
        definition: Definition<ComponentA>((s) => ComponentA()),
        scopeDefinition: rootScope.scopeDefinition,
        options: Options());
    var def2 = Definitions.createSingle(
        definition: Definition<ComponentA>((s) => ComponentA()),
        scopeDefinition: rootScope.scopeDefinition,
        options: Options());

    expect(def1, def2);
  });

  test('scope definition', () {
    var def1 = Definitions.createSingle(
        definition: Definition<ComponentA>((s) => ComponentA()),
        scopeDefinition: rootScope.scopeDefinition,
        options: Options());

    expect(def1.scopeDefinition, rootScope.scopeDefinition);
    expect(def1.kind, Kind.single);
  });

  test('equals definitions - but diif kind', () {
    var def1 = Definitions.createSingle(
        definition: Definition<ComponentA>((s) => ComponentA()),
        scopeDefinition: rootScope.scopeDefinition,
        options: Options());
    var def2 = Definitions.createSingle(
        definition: Definition<ComponentA>((s) => ComponentA()),
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
        definitionParameter: emptyParameter()));

    expect(instance, app.koin.get<ComponentA>());
  });

  test('indexKey', () {
    var type = ComponentA;
    var id = indexKey(type, null);

    expect(id, 'ComponentA');
  });
}
