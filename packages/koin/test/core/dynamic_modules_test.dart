import 'package:koin/koin.dart';
import 'package:koin/src/context/context_functions.dart';
import 'package:koin/src/context/context_handler.dart';
import 'package:koin/src/internal/exceptions.dart';
import 'package:test/test.dart';

import '../components.dart';
import 'package:koin/src/definition/provider_definition.dart';
import '../extensions/koin_application_ext.dart';
import 'package:koin/src/qualifier.dart';

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

  test('should unload modules with single definition', () {
    final currentModule = module()..single((s) => ComponentA());
    final currentModuleB = module()..single((s) => ComponentB(s.get()));

    final app = koinApplication((app) {
      app.printLogger();
      app.modules([currentModule, currentModuleB]);
    });

    var defA = app.getBeanDefinition(ComponentA);
    var defB = app.getBeanDefinition(ComponentB);

    expect(Kind.single, defA.kind);
    expect(app.koin.get<ComponentA>(), isNotNull);

    expect(Kind.single, defB.kind);
    expect(app.koin.get<ComponentB>(), isNotNull);

    app.unloadModules([currentModule, currentModuleB]);

    expect(app.getBeanDefinition(ComponentA), isNull);
    expect(app.getBeanDefinition(ComponentB), isNull);

    expect(() => app.koin.get<ComponentA>(),
        throwsA((value) => value is NoBeanDefFoundException));

    expect(() => app.koin.get<ComponentB>(),
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

    app.unloadModules([module2]);

    expect(app.getBeanDefinition(MySingle), isNull);

    expect(() => app.koin.get<MySingle>(),
        throwsA((value) => value is NoBeanDefFoundException));
  });

  test('should reload module definition', () {
    final currentModule = module()
      ..singleWithParam<MySingle, int>((s, id) => MySingle(id));

    final app = koinApplication((app) {
      app.printLogger();
      app.module(currentModule);
    });

    var koin = app.koin;

    expect(
      42,
      app.koin.getWithParam<MySingle, int>(42).id,
    );

    koin.unloadModule(currentModule);
    koin.loadModule(currentModule);

    expect(app.getBeanDefinition(MySingle), isNotNull);

    expect(
      24,
      app.koin.getWithParam<MySingle, int>(24).id,
    );
  });

  test('should reload module definition - global context', () {
    final currentModule = module()
      ..singleWithParam<MySingle, int>((s, id) => MySingle(id));

    startKoin((app) {
      app.module(currentModule);
    });

    expect(
      42,
      KoinContextHandler.get().getWithParam<MySingle, int>(42).id,
    );

    unloadKoinModule(currentModule);
    loadKoinModule(currentModule);

    expect(
      24,
      KoinContextHandler.get().getWithParam<MySingle, int>(24).id,
    );

    stopKoin();
  });

  test('should reload modules definition - global context', () {
    final currentModule = module()
      ..singleWithParam<MySingle, int>((s, id) => MySingle(id));

    startKoin((app) {
      app.module(currentModule);
    });

    expect(
      42,
      KoinContextHandler.get().getWithParam<MySingle, int>(42).id,
    );

    unloadKoinModules([currentModule]);
    loadKoinModules([currentModule]);

    expect(
      24,
      KoinContextHandler.get().getWithParam<MySingle, int>(24).id,
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

    var scope = app.koin.createScopeWithQualifier('id', named<ScopeKey>());
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

    var scope = app.koin.createScopeWithQualifier('id', named<ScopeKey>());
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

    var scope = KoinContextHandler.get()
        .createScopeWithQualifier('id', named<ScopeKey>());
    expect(scope.getBeanDefinition(ComponentA), isNotNull);

    unloadKoinModule(currentModule);
    loadKoinModule(currentModule);

    expect(scope.get<ComponentA>(), isNotNull);
    stopKoin();
  });
}

class ScopeKey {}
