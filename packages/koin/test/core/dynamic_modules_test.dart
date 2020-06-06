import 'package:koin/src/core/context/context_functions.dart';
import 'package:koin/src/core/context/koin_context_handler.dart';
import 'package:koin/src/core/error/exceptions.dart';
import 'package:test/test.dart';
import 'package:koin/src/dsl/module_dsl.dart';

import '../components.dart';
import 'package:koin/src/dsl/koin_application_dsl.dart';
import 'package:koin/src/core/definition/bean_definition.dart';
import '../extensions/koin_application_ext.dart';
import 'package:koin/src/core/definition_parameters.dart';
import 'package:koin/src/core/qualifier.dart';

void main() {
  test('should unload single definition', () {
    final currentModule = module()..single((s) => ComponentA());

    final app = koinApplication((app) {
      app.printLogger();
      app.module(currentModule);
    });

    var defA = app.getBeanDefinition(ComponentA);

    expect(Kind.single, defA.kind);
    expect(app.koin.get<ComponentA>(), isNotNull);

    app.unloadModule(currentModule);

    expect(app.getBeanDefinition(ComponentA), isNull);

    expect(() => app.koin.get<ComponentA>(),
        throwsA((value) => value is NoBeanDefFoundException));
  });

  test('should unload additional bound definition', () {
    final currentModule = module()
      ..single((s) => Component1()).bind<ComponentInterface1>();

    final app = koinApplication((app) {
      app.printLogger();
      app.module(currentModule);
    });

    var defA = app.getBeanDefinition(Component1);
    expect(Kind.single, defA.kind);

    expect(app.koin.get<Component1>(), isNotNull);
    expect(app.koin.get<ComponentInterface1>(), isNotNull);

    app.unloadModule(currentModule);

    expect(app.getBeanDefinition(Component1), isNull);
    expect(app.getBeanDefinition(ComponentInterface1), isNull);

    expect(() => app.koin.get<Component1>(),
        throwsA((value) => value is NoBeanDefFoundException));

    expect(() => app.koin.get<ComponentInterface1>(),
        throwsA((value) => value is NoBeanDefFoundException));
  });

  test('should unload one module definition', () {
    final module1 = module()..single((s) => ComponentA());
    final module2 = module()..single((s) => ComponentB(s.get()));

    final app = koinApplication((app) {
      app.printLogger();
      app.modules([module1, module2]);
    });

    app.getBeanDefinition(ComponentA);
    app.getBeanDefinition(ComponentB);

    expect(app.koin.get<ComponentA>(), isNotNull);
    expect(app.koin.get<ComponentB>(), isNotNull);

    app.unloadModule(module2);

    expect(app.getBeanDefinition(ComponentB), isNull);

    expect(() => app.koin.get<ComponentB>(),
        throwsA((value) => value is NoBeanDefFoundException));
  });

  test('should unload one module definition - factory', () {
    final module1 = module()..single((s) => ComponentA());
    final module2 = module()..factory((s) => ComponentB(s.get()));

    final app = koinApplication((app) {
      app.printLogger();
      app.modules([module1, module2]);
    });

    app.getBeanDefinition(ComponentA);
    app.getBeanDefinition(ComponentB);

    expect(app.koin.get<ComponentA>(), isNotNull);
    expect(app.koin.get<ComponentB>(), isNotNull);

    app.unloadModule(module2);

    expect(app.getBeanDefinition(ComponentB), isNull);

    expect(() => app.koin.get<ComponentB>(),
        throwsA((value) => value is NoBeanDefFoundException));
  });

  test('should unload module override definition', () {
    final module1 = module()..single((s) => MySingle(42));
    final module2 = module(override: true)..single((s) => MySingle(24));

    final app = koinApplication((app) {
      app.printLogger();
      app.modules([module1, module2]);
    });

    if (app.getBeanDefinition(MySingle) == null) {
      throwsA('no definition found');
    }

    expect(24, app.koin.get<MySingle>().id);

    app.unloadModule(module2);

    expect(app.getBeanDefinition(MySingle), isNull);

    expect(() => app.koin.get<MySingle>(),
        throwsA((value) => value is NoBeanDefFoundException));
  });

  test('should reload module definition', () {
    final currentModule = module()
      ..single1<MySingle, int>((s, id) => MySingle(id));

    final app = koinApplication((app) {
      app.printLogger();
      app.module(currentModule);
    });

    var koin = app.koin;

    expect(
      42,
      app.koin.getWithParams<MySingle>(parameters: parametersOf([42])).id,
    );

    koin.unloadModule(currentModule);
    koin.loadModule(currentModule);

    expect(app.getBeanDefinition(MySingle), isNotNull);

    expect(
      24,
      app.koin.getWithParams<MySingle>(parameters: parametersOf([24])).id,
    );
  });

  test('should reload module definition - global context', () {
    final currentModule = module()
      ..single1<MySingle, int>((s, id) => MySingle(id));

    startKoin((app) {
      app.module(currentModule);
    });

    expect(
      42,
      KoinContextHandler.get()
          .getWithParams<MySingle>(parameters: parametersOf([42]))
          .id,
    );

    unloadKoinModule(currentModule);
    loadKoinModule(currentModule);

    expect(
      24,
      KoinContextHandler.get()
          .getWithParams<MySingle>(parameters: parametersOf([24]))
          .id,
    );

    stopKoin();
  });

  test('should unload scoped definition', () {
    final currentModule = module()
      ..scope<ScopeKey>((s) {
        s.scoped((s) => ComponentA());
      });

    final app = koinApplication((app) {
      app.printLogger();
      app.module(currentModule);
    });

    var scope = app.koin.createScope('id', named<ScopeKey>());
    var defA = scope.getBeanDefinition(ComponentA);

    expect(Kind.single, defA.kind);
    expect(named<ScopeKey>(), defA.scopeDefinition.qualifier);

    expect(scope.getBeanDefinition(ComponentA), isNotNull);

    app.unloadModule(currentModule);

    expect(scope.getBeanDefinition(ComponentA), isNull);

    expect(() => scope.get<ComponentA>(),
        throwsA((value) => value is NoBeanDefFoundException));
  });

  test('should reload scoped definition', () {
    final currentModule = module()
      ..scope<ScopeKey>((s) {
        s.scoped((s) => ComponentA());
      });

    final app = koinApplication((app) {
      app.printLogger();
      app.module(currentModule);
    });

    var koin = app.koin;

    var scope = app.koin.createScope('id', named<ScopeKey>());
    var defA = scope.getBeanDefinition(ComponentA);

    expect(Kind.single, defA.kind);
    expect(named<ScopeKey>(), defA.scopeDefinition.qualifier);
    expect(scope.getBeanDefinition(ComponentA), isNotNull);

    koin.unloadModule(currentModule);
    koin.loadModule(currentModule);

    scope.get<ComponentA>();
    expect(scope.getBeanDefinition(ComponentA), isNotNull);
  });

  test('should reload scoped definition - global', () {
    final currentModule = module()
      ..scope<ScopeKey>((s) {
        s.scoped((s) => ComponentA());
      });

    startKoin((app) {
      app.printLogger();
      app.module(currentModule);
    });

    var scope = KoinContextHandler.get().createScope('id', named<ScopeKey>());
    expect(scope.getBeanDefinition(ComponentA), isNotNull);

    unloadKoinModule(currentModule);
    loadKoinModule(currentModule);

    expect(scope.get<ComponentA>(), isNotNull);
    stopKoin();
  });
}

class ScopeKey {}
