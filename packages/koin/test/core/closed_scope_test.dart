import 'package:koin/koin.dart';
import 'package:koin/src/context/context_functions.dart';
import 'package:test/test.dart';
import 'package:koin/internals.dart';
import '../components.dart';

class ScopeType {}

class CustomSingle {
  int id;

  CustomSingle(this.id);
}

void main() {
  var scopeName = 'MY_SCOPE';

  test('get definition from current scopes type', () {
    var koin = KoinApplication()
        .printLogger()
        .module(Module()
          ..scope<ScopeType>((scope) {
            scope.scoped((s) => ComponentA());
          }))
        .koin
      ..createEagerInstances();

    var scope1 = koin.createScopeWithQualifier('scope1', named<ScopeType>());
    var scope2 = koin.createScopeWithQualifier('scope2', named<ScopeType>());

    expect(scope1.get<ComponentA>(), isNot(equals(scope2.get<ComponentA>())));
  });

  test('get definition from current scope with have ony one definition ', () {
    var koin = KoinApplication()
        .printLogger(level: Level.debug)
        .module(
            Module()..scopeOne<ComponentA, ScopeType>((scope) => ComponentA()))
        .koin;

    var scope1 = koin.createScope<ScopeType>('scope1');
    var scope2 = koin.createScope<ScopeType>('scope2');

    expect(scope1.get<ComponentA>(), isNot(equals(scope2.get<ComponentA>())));
  });

  test('close definitions not initiated', () {
    startKoin((app) {
      app.printLogger(level: Level.debug).module(Module()
        ..scope<ScopeType>((scope) {
          scope.scoped((s) => MySingle(10))
            ..onClose((a) {
              print(a.id);
            }, onDisposeUnitialized: () {});
        }));
    }).koin;

    // var scope1 = koin.createScope('scope1', named<ScopeType>());
    // var scope2 = koin.createScope('scope2', named<ScopeType>());
    stopKoin();

    // expect(scope1.closed, true);
    // expect(scope2.closed, true);
  });

  test('close definitions', () {
    var koin = startKoin((app) {
      app.printLogger().module(Module()
        ..scope<ScopeType>((scope) {
          scope.scoped((s) => CustomSingle(10))
            ..onClose((a) {
              a.id = 50;
            }, onDisposeUnitialized: () {});
        }));
    }).koin;

    var scope1 = koin.createScopeWithQualifier('scope1', named<ScopeType>());
    var mySingle = scope1.get<CustomSingle>();

    stopKoin();
    expect(scope1.closed, true);
    expect(mySingle.id, 50);
  });

  test('stopping Koin closes Scopes', () {
    var koin = startKoin((app) {
      app.printLogger().module(Module()
        ..scope<ScopeType>((scope) {
          scope.scoped((s) => ComponentA());
        }));
    }).koin;

    var scope1 = koin.createScopeWithQualifier('scope1', named<ScopeType>());
    var scope2 = koin.createScopeWithQualifier('scope2', named<ScopeType>());
    stopKoin();

    expect(scope1.closed, true);
    expect(scope2.closed, true);
  });

  test('stopping Koin closes Scopes -scopeOne', () {
    var koin = startKoin((app) {
      app.printLogger().module(
          Module()..scopeOne<ComponentA, ScopeType>((scope) => ComponentA()));
    }).koin;

    var scope1 = koin.createScope<ScopeType>('scope1');
    var scope2 = koin.createScope<ScopeType>('scope2');
    stopKoin();

    expect(scope1.closed, true);
    expect(scope2.closed, true);
  });

  test('get definition from current scope type', () {
    var koin = KoinApplication()
        .printLogger()
        .module(Module()
          ..scope<ScopeType>((scope) {
            scope.scoped((s) => ComponentA());
            scope.scoped((s) => ComponentB(s.get()));
          }))
        .koin;

    var scope = koin.createScopeWithQualifier('myScope', named<ScopeType>());
    var scope2 = koin.getOrCreateScopeQualifier('myScope', named<ScopeType>());
    var scope3 = koin.getOrCreateScope<ScopeType>('myScope');

    expect(scope, scope2);
    expect(scope, scope3);
    expect(scope.get<ComponentB>(), scope.get<ComponentB>());
    expect(scope.get<ComponentA>(), scope.get<ComponentB>().a);
  });

  test('get definition from current factory scope type', () {
    var koin = KoinApplication()
        .printLogger()
        .module(Module()
          ..scope<ScopeType>((scope) {
            scope.scoped((s) => ComponentA());
            scope.factory((s) => ComponentB(s.get()));
          }))
        .koin;
    var scope = koin.createScopeWithQualifier('myScope', named<ScopeType>());

    expect(scope.get<ComponentB>(), isNot(equals(scope.get<ComponentB>())));
    expect(scope.get<ComponentA>(), scope.get<ComponentB>().a);
  });

  test('get definition from factory scope type', () {
    var koin = koinApplication((app) {
      app.printLogger().module(Module()
        ..single((s) => ComponentA())
        ..scope<ScopeType>((scope) {
          scope.factory((s) {
            var test = ComponentB(s.get<ComponentA>());
            return test;
          });
        }));
    }).koin;

    var scope = koin.createScopeWithQualifier('myScope', named<ScopeType>());

    expect(scope.get<ComponentB>(), isNot(equals(scope.get<ComponentB>())));
    expect(scope.get<ComponentA>(), scope.get<ComponentB>().a);
  });
  test('get definition from current scope type - dispatched modules ', () {
    var koin = KoinApplication().printLogger().modules([
      Module()..scope<ScopeType>((scope) => scope),
      Module()..scope<ScopeType>((scope) => scope.scoped((s) => ComponentA())),
      Module()
        ..scope<ScopeType>((scope) => scope.scoped((s) => ComponentB(s.get())))
    ]).koin;

    var scope = koin.createScopeWithQualifier('myScope', named<ScopeType>());

    expect(scope.get<ComponentB>(), scope.get<ComponentB>());
    expect(scope.get<ComponentA>(), scope.get<ComponentB>().a);
  });

  test('get definition from current scope type - with named string qualifier',
      () {
    var koin = KoinApplication()
        .printLogger()
        .module(Module()
          ..scopeWithType(named(scopeName), (scope) {
            scope.scoped((s) => ComponentA());
          }))
        .koin;
    var scope1 = koin.createScopeWithQualifier('scope1', named(scopeName));
    var scope2 = koin.createScopeWithQualifier('scope2', named(scopeName));

    expect(scope1.get<ComponentA>(), isNot(equals(scope2.get<ComponentA>())));
  });

  test('get definition from current scope - with named string qualifier', () {
    var koin = KoinApplication()
        .printLogger()
        .module(Module()
          ..scopeWithType(named(scopeName), (scope) {
            scope.scoped((s) => ComponentA());
            scope.scoped((s) => ComponentB(s.get()));
          }))
        .koin;
    var scope = koin.createScopeWithQualifier('myScope', named(scopeName));

    expect(scope.get<ComponentB>(), scope.get<ComponentB>());
    expect(scope.get<ComponentA>(), scope.get<ComponentB>().a);
  });
  test('get definition from outside single', () {
    var koin = KoinApplication()
        .printLogger()
        .module(Module()
          ..single((s) => ComponentA())
          ..scopeWithType(named(scopeName), (scope) {
            scope.scoped((s) => ComponentB(s.get()));
          }))
        .koin;
    var scope = koin.createScopeWithQualifier('myScope', named(scopeName));

    expect(scope.get<ComponentB>(), scope.get<ComponentB>());
    expect(scope.get<ComponentA>(), scope.get<ComponentB>().a);
  });
  test('get definition from outside factory', () {
    var koin = KoinApplication()
        .printLogger()
        .module(Module()
          ..factory((s) => ComponentA())
          ..scopeWithType(named(scopeName), (scope) {
            scope.scoped((s) => ComponentB(s.get()));
          }))
        .koin;
    var scope = koin.createScopeWithQualifier('myScope', named(scopeName));

    expect(scope.get<ComponentB>(), scope.get<ComponentB>());
    expect(scope.get<ComponentA>(), isNot(equals(scope.get<ComponentB>().a)));
  });

  test('bad mix definition from a scope', () {
    var koin = KoinApplication()
        .printLogger()
        .module(Module()
          ..scopeWithType(named(scopeName), (scope) {
            scope.scoped((s) => ComponentB(s.get()));
          }))
        .koin;
    var scope = koin.createScopeWithQualifier('myScope', named(scopeName));

    try {
      scope.get<ComponentA>();
      fail('message');
    } catch (error) {
      print(error.toString());
    }
  });

  test('mix definition from a scope', () {
    var koin = KoinApplication()
        .printLogger()
        .module(Module()
          ..scopeWithType(named('SCOPE_1'), (scope) {
            scope.scoped((s) => ComponentA());
          })
          ..scopeWithType(named('SCOPE_2'), (scope) {
            scope.scopedWithParam<ComponentB, Scope>((s, scope) {
              return ComponentB(scope.get());
            });
          }))
        .koin;
    var scope1 = koin.createScopeWithQualifier('myScope1', named('SCOPE_1'));
    var scope2 = koin.createScopeWithQualifier('myScope2', named('SCOPE_2'));
    var b = scope2.getWithParam<ComponentB, Scope>(scope1);
    var a = scope1.get<ComponentA>();

    expect(a, b.a);
  });

  test('definition params for scoped definitions', () {
    var koin = KoinApplication()
        .printLogger()
        .module(Module()
          ..scopeWithType(named('SCOPE_1'), (scope) {
            scope.scopedWithParam<MySingle, int>((s, id) => MySingle(id));
          }))
        .koin;

    var scope1 = koin.createScopeWithQualifier('myScope1', named('SCOPE_1'));
    var parameters = 42;
    var a = scope1.getWithParam<MySingle, int>(42);
    expect(parameters, a.id);
  });
}
