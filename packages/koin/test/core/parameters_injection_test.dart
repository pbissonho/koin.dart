import 'package:koin/koin.dart';
import 'package:koin/src/internal/exceptions.dart';
import 'package:test/test.dart';

import '../components.dart';

class MySingle2 {
  final int id;
  final String name;

  MySingle2(this.id, this.name);
}

class MySingle3 {
  final int id;
  final String name;
  final String lastName;

  MySingle3(this.id, this.name, this.lastName);
}

void main() {
  test('can create a single with parameters', () {
    var app = koinApplication((app) {
      app.module(
          Module()..singleWithParam<MySingle, int>((s, id) => MySingle(id)));
    });

    var a = app.koin.getWithParam<MySingle, int>(42);

    expect(a.id, 42);
  });

  test('can create a single with parameters - inject', () {
    var app = koinApplication((app) {
      app.module(
          Module()..singleWithParam<MySingle, int>((s, id) => MySingle(id)));
    });

    var a = app.koin.injectWithParam<MySingle, int>(42);

    expect(a.value?.id, 42);
  });

  test('can create a scoped with parameters', () {
    var scopeKey = named('ScopeKey');

    var app = koinApplication((app) {
      app.module(Module()
        ..scopeWithType(scopeKey, (s) {
          s.scopedWithParam<MySingle, int>((s, id) => MySingle(id));
        }));
    });

    var scope = app.koin.createScopeWithQualifier('scopeId', scopeKey);

    var a = scope.getWithParam<MySingle, int>(42);
    var lazyA = scope.injectWithParam<MySingle, int>(42);

    expect(a.id, 42);
    expect(lazyA.value?.id, 42);
  });

  test('can get a single created with parameters - no need of give it again',
      () {
    var app = koinApplication((app) {
      app.module(
          Module()..singleWithParam<MySingle, int>((s, id) => MySingle(id)));
    });

    var a = app.koin.getWithParam<MySingle, int>(42);
    var a2 = app.koin.get<MySingle>();
    var a3 = app.koin.get<MySingle>();

    expect(a.id, 42);
    expect(a2.id, 42);
    expect(a3.id, 42);
  });

  test('can create a factories with parameters', () {
    var app = koinApplication((app) {
      app.module(
          Module()..factoryWithParam<MySingle, int>((s, id) => MySingle(id)));
    });

    var a = app.koin.getWithParam<MySingle, int>(42);
    var b = app.koin.getWithParam<MySingle, int>(43);
    var lazyB = app.koin.injectWithParam<MySingle, int>(43);

    expect(a.id, 42);
    expect(b.id, 43);
    expect(lazyB()?.id, 43);
  });

  test('can create a factories scoped with parameters', () {
    var scopeKey = named('ScopeKey');

    var app = koinApplication((app) {
      app.module(Module()
        ..scopeWithType(scopeKey, (s) {
          s.factoryWithParam<MySingle, int>((s, id) => MySingle(id));
        }));
    });

    var scope = app.koin.createScopeWithQualifier('myScope', scopeKey);

    var a = scope.getWithParam<MySingle, int>(42);
    var b = scope.getWithParam<MySingle, int>(43);

    expect(a.id, 42);
    expect(b.id, 43);
  });

  // TODO
  // Analyze if it is really necessary.
  test('shoud trow a exception when not pass parameters - getWithParams', () {
    var app = koinApplication((app) {
      app.module(
          Module()..singleWithParam<MySingle, int>((s, id) => MySingle(id)));
    });

    final mySingle = app.koin.get<MySingle>();

    expect(() => app.koin.get<MySingle>(),
        throwsA(isA<InstanceCreationException>()));
    print(mySingle);
  }, skip: true);
}
