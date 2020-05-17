import 'package:koin/koin.dart';
import 'package:koin/src/core/context/context_functions.dart';
import 'package:koin/src/core/error/exceptions.dart';
import 'package:test/test.dart';

import '../components.dart';
import 'setter_inject_test.dart';
import 'package:koin/src/ext/instance_scope_ext.dart';

void main() {
  tearDown(() {
    stopKoin();
  });

  test('typed scope', () {
    var koin = koinApplication((app) {
      app.module(Module()
        ..single((s) => A())
        ..scope<A>((s) {
          s.scoped((s) => B());
          s.scoped((s) => C());
        }));
    }).koin;

    expect(koin.get<A>(), isNotNull);
    expect(koin.getOrNull<B>(), isNull);
    expect(koin.getOrNull<C>(), isNull);
  });

  test('typed scope & source', () {
    var koin = startKoin((app) {
      app.module(Module()
        ..single((s) => A())
        ..scope<A>((s) {
          s.scoped((s) => BofA(s.getSource()));
        })
        ..scope<BofA>((s) {
          s.scoped((s) => CofB(s.getSource()));
        }));
    }).koin;

    var a = koin.get<A>();
    var b = a.scope.get<BofA>();

    expect(b.a, a);

    var c = b.scope.get<CofB>();
    expect(c.b, b);
  });

  test('typed scope & source with get', () {
    var koin = startKoin((app) {
      app.module(Module()
        ..single((s) => A())
        ..scope<A>((s) {
          s.scoped((s) => BofA(s.get()));
        })
        ..scope<BofA>((s) {
          s.scoped((s) => CofB(s.get()));
        }));
    }).koin;

    var a = koin.get<A>();
    var b = a.scope.get<BofA>();

    expect(b.a, a);

    var c = b.scope.get<CofB>();
    expect(c.b, b);
  }, skip: true);

  test('scope from instance object', () {
    var koin = startKoin((app) {
      app.module(Module()
        ..single((s) => A())
        ..scope<A>((s) {
          s.scoped((s) => B());
          s.scoped((s) => C());
        }));
    }).koin;

    var a = koin.get<A>();
    var scopeForA = koin.createScopeT2<A>();

    var b1 = scopeForA.get<B>();

    expect(b1, isNotNull);
    expect(scopeForA.get<C>(), isNotNull);

    scopeForA.close();

    expect(scopeForA.getOrNull<B>(), isNull);
    expect(scopeForA.getOrNull<C>(), isNull);

    var scopeForA2 = koin.createScopeT2<A>();

    var b2 = scopeForA2.getOrNull<B>();
    expect(b2, isNotNull);
    expect(b1, isNot(b2));
  });

  test('scope property', () {
    var koin = startKoin((app) {
      app.module(Module()
        ..single((s) => A())
        ..scope<A>((s) {
          s.scoped((s) => B());
          s.scoped((s) => C());
        }));
    }).koin;

    var a = koin.get<A>();

    var b1 = a.scope.get<B>();
    expect(b1, isNotNull);
    expect(a.scope.get<C>(), isNotNull);

    a.scope.close();

    var b2 = a.scope.get<B>();
    expect(b2, isNotNull);
    expect(a.scope.get<C>(), isNotNull);
    expect(b1, isNot(b2));
  });

  test('scope property 2', () {
    var koin = startKoin((app) {
      app.module(Module()
        ..single((s) => A())
        ..scope<A>((s) {
          s.scoped((s) => B());
        }));
    }).koin;

    var a = koin.get<A>();

    var b1 = a.scope.get<B>();

    a.scope.close();

    var b2 = a.scope.get<B>();

    expect(b1, isNot(b2));
  });

  test('scope property - koin isolation', () {
    var koin = startKoin((app) {
      app.module(Module()
        ..single((s) => A())
        ..scope<A>((s) {
          s.scoped((s) => B());
        }));
    }).koin;

    var a = koin.get<A>();

    // get current scope
    var scope = a.getOrCreateScope(koin);
    var b1 = scope.get<B>();
    scope.close();

    scope = a.getOrCreateScope(koin);
    // recreate a new scope
    var b2 = scope.get<B>();

    expect(b1, isNot(b2));
  });

  test('cascade scope', () {
    var koin = startKoin((app) {
      app.module(Module()
        ..single((s) => A())
        ..scope<A>((s) {
          s.scoped((s) => B());
        })
        ..scope<B>((s) {
          s.scoped((s) => C());
        }));
    }).koin;

    var a = koin.get<A>();
    var b1 = a.scope.get<B>();
    var c1 = b1.scope.get<C>();

    a.scope.close();
    b1.scope.close();

    var b2 = a.scope.get<B>();
    var c2 = b2.scope.get<C>();

    expect(b1, isNot(b2));
    expect(c1, isNot(c2));
  });

  test('cascade linked scope', () {
    var koin = startKoin((app) {
      app.module(Module()
        ..single((s) => A())
        ..scope<A>((s) {
          s.scoped((s) => B());
        })
        ..scope<B>((s) {
          s.scoped((s) => C());
        }));
    }).koin;

    var a = koin.get<A>();
    var b = a.scope.get<B>();
    a.scope.linkTo([b.scope]);
    expect(a.scope.get<C>(), b.scope.get<C>());
  });

  test('cascade unlink scope', () {
    var koin = startKoin((app) {
      app.module(Module()
        ..single((s) => A())
        ..scope<A>((s) {
          s.scoped((s) => B());
        })
        ..scope<B>((s) {
          s.scoped((s) => C());
        }));
    }).koin;

    var a = koin.get<A>();
    var b1 = a.scope.get<B>();
    a.scope.linkTo([b1.scope]);
    var c1 = a.scope.get<C>();
    expect(c1, isNotNull);

    a.scope.unlink([b1.scope]);
    expect(a.scope.getOrNull<C>(), isNull);
  });

  test('shared linked scope', () {
    var koin = startKoin((app) {
      app.module(Module()
        ..scope<A>((s) {
          s.scoped((s) => ComponentB(s.get()));
        })
        ..scope<B>((s) {
          s.scoped((s) => ComponentB(s.get()));
        })
        ..scope<C>((s) {
          s.scoped<ComponentA>((s) => ComponentA());
        }));
    }).koin;

    var scopeA = koin.createScopeT2<A>();
    var scopeB = koin.createScopeT2<B>();
    var scopeC = koin.createScopeT2<C>();
    scopeA.linkTo([scopeC]);
    scopeB.linkTo([scopeC]);

    var compb_scopeA = scopeA.get<ComponentB>();
    var compb_scopeB = scopeB.get<ComponentB>();

    expect(compb_scopeA, isNot(compb_scopeB));

    expect(compb_scopeA.a, compb_scopeB.a);
  });

  test('error for root linked scope', () {
    var koin = startKoin((app) {
      app.module(Module()
        ..single((s) => A())
        ..scope<A>((s) {
          s.scoped((s) => B());
        }));
    }).koin;

    var a = koin.get<A>();

    expect(() => koin.scopeRegistry.rootScope.linkTo([a.scope]),
        throwsA(isA<IllegalStateException>()));
  });
}
