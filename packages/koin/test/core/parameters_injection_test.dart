import 'package:koin/koin.dart';
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
      app.module(Module()..single1<MySingle, int>((s, id) => MySingle(id)));
    });

    var a = app.koin.getWithParams<MySingle>(parameters: parametersOf([42]));

    expect(a.id, 42);
  });

  test('can create a scoped with parameters', () {
    var scopeKey = named('ScopeKey');

    var app = koinApplication((app) {
      app.module(Module()
        ..scopeWithType(scopeKey, (s) {
          s.scoped1<MySingle, int>((s, id) => MySingle(id));
        }));
    });

    var scope = app.koin.createScope('scopeId', scopeKey);

    var a = scope.getParams<MySingle>(parameters: parametersOf([42]));

    expect(a.id, 42);
  });

  test('can create a scoped with 2 parameters', () {
    var scopeKey = named('ScopeKey');

    var app = koinApplication((app) {
      app.module(Module()
        ..scopeWithType(scopeKey, (s) {
          s.scoped2<MySingle2, int, String>(
              (s, id, name) => MySingle2(id, name));
        }));
    });

    var scope = app.koin.createScope('scopeId', scopeKey);

    var a =
        scope.getParams<MySingle2>(parameters: parametersOf([42, 'myString']));

    expect(a.id, 42);
    expect(a.name, 'myString');
  });

  test('can create a scoped with 3 parameters', () {
    var scopeKey = named('ScopeKey');

    var app = koinApplication((app) {
      app.module(Module()
        ..scopeWithType(scopeKey, (s) {
          s.scoped3<MySingle3, int, String, String>(
              (s, id, name, last) => MySingle3(id, name, last));
        }));
    });

    var scope = app.koin.createScope('scopeId', scopeKey);

    var a = scope.getParams<MySingle3>(
        parameters: parametersOf([42, 'myString', 'myString2']));

    expect(a.id, 42);
    expect(a.name, 'myString');
    expect(a.lastName, 'myString2');
  });

  test('can create a single2 with parameters', () {
    var app = koinApplication((app) {
      app.module(Module()
        ..single2<MySingle2, int, String>(
            (s, id, name) => MySingle2(id, name)));
    });

    var a = app.koin
        .getWithParams<MySingle2>(parameters: parametersOf([42, 'myString']));

    expect(a.id, 42);
    expect(a.name, 'myString');
  });

  test('can create a single3 with parameters', () {
    var app = koinApplication((app) {
      app.module(Module()
        ..single3<MySingle3, int, String, String>(
            (s, id, name, lastName) => MySingle3(id, name, lastName)));
    });

    var a = app.koin.getWithParams<MySingle3>(
        parameters: parametersOf([42, 'myString', 'lastName']));

    expect(a.id, 42);
    expect(a.name, 'myString');
    expect(a.lastName, 'lastName');
  });

  test('can get a single created with parameters - no need of give it again',
      () {
    var app = koinApplication((app) {
      app.module(Module()..single1<MySingle, int>((s, id) => MySingle(id)));
    });

    var a = app.koin.getWithParams<MySingle>(parameters: parametersOf([42]));
    var a2 = app.koin.get<MySingle>();
    var a3 =
        app.koin.getWithParams<MySingle>(parameters: emptyParametersHolder());

    expect(a.id, 42);
    expect(a2.id, 42);
    expect(a3.id, 42);
  });

  test('can create a factories with parameters', () {
    var app = koinApplication((app) {
      app.module(Module()..factory1<MySingle, int>((s, id) => MySingle(id)));
    });

    var a = app.koin.getWithParams<MySingle>(parameters: parametersOf([42]));
    var b = app.koin.getWithParams<MySingle>(parameters: parametersOf([43]));

    expect(a.id, 42);
    expect(b.id, 43);
  });

  test('an create a factories with 2 parameters', () {
    var app = koinApplication((app) {
      app.module(Module()
        ..factory2<MySingle2, int, String>(
            (s, id, name) => MySingle2(id, name)));
    });

    var a = app.koin
        .getWithParams<MySingle2>(parameters: parametersOf([42, 'myString']));

    var b = app.koin
        .getWithParams<MySingle2>(parameters: parametersOf([43, 'myString2']));

    expect(a.id, 42);
    expect(a.name, 'myString');

    expect(b.id, 43);
    expect(b.name, 'myString2');
  });

  test('an create a factories with 2 parameters', () {
    var app = koinApplication((app) {
      app.module(Module()
        ..factory3<MySingle3, int, String, String>(
            (s, id, name, lastName) => MySingle3(id, name, lastName)));
    });

    var a = app.koin.getWithParams<MySingle3>(
        parameters: parametersOf([42, 'myString', 'lastName']));

    var b = app.koin.getWithParams<MySingle3>(
        parameters: parametersOf([45, 'myString2', 'lastName2']));

    expect(a.id, 42);
    expect(a.name, 'myString');
    expect(a.lastName, 'lastName');
    expect(b.id, 45);
    expect(b.name, 'myString2');
    expect(b.lastName, 'lastName2');
  });

  test('can create a factories scoped with parameters', () {
    var scopeKey = named('ScopeKey');

    var app = koinApplication((app) {
      app.module(Module()
        ..scopeWithType(scopeKey, (s) {
          s.factory1<MySingle, int>((s, id) => MySingle(id));
        }));
    });

    var scope = app.koin.createScope('myScope', scopeKey);

    var a = scope.getParams<MySingle>(parameters: parametersOf([42]));
    var b = scope.getParams<MySingle>(parameters: parametersOf([43]));

    expect(a.id, 42);
    expect(b.id, 43);
  });

  test('can create a factories scoped with 2 parameters', () {
    var scopeKey = named('ScopeKey');

    var app = koinApplication((app) {
      app.module(Module()
        ..scopeWithType(scopeKey, (s) {
          s.factory2<MySingle2, int, String>(
              (s, id, name) => MySingle2(id, name));
        }));
    });

    var scope = app.koin.createScope('myScope', scopeKey);

    var a =
        scope.getParams<MySingle2>(parameters: parametersOf([42, 'myString']));

    var b =
        scope.getParams<MySingle2>(parameters: parametersOf([43, 'myString2']));

    expect(a.id, 42);
    expect(a.name, 'myString');

    expect(b.id, 43);
    expect(b.name, 'myString2');
  });

  test('can create a factories scoped with 3 parameters', () {
    var scopeKey = named('ScopeKey');

    var app = koinApplication((app) {
      app.module(Module()
        ..scopeWithType(scopeKey, (s) {
          s
            ..factory3<MySingle3, int, String, String>(
                (s, id, name, lastName) => MySingle3(id, name, lastName));
        }));
    });

    var scope = app.koin.createScope('myScope', scopeKey);

    var a = scope.getParams<MySingle3>(
        parameters: parametersOf([42, 'myString', 'lastName']));

    var b = scope.getParams<MySingle3>(
        parameters: parametersOf([45, 'myString2', 'lastName2']));

    expect(a.id, 42);
    expect(a.name, 'myString');
    expect(a.lastName, 'lastName');
    expect(b.id, 45);
    expect(b.name, 'myString2');
    expect(b.lastName, 'lastName2');
  });

  test('chained factory injection', () {
    var koin = koinApplication((app) {
      app.module(Module()
        ..factory1<MyIntFactory, int>((s, id) => MyIntFactory(id))
        ..factory1<MyStringFactory, String>((s, id) => MyStringFactory(id))
        ..factory2<AllFactory, int, String>((s, idInt, idString) => AllFactory(
            s.getParams(parameters: parametersOf([idInt])),
            s.getParams(parameters: parametersOf([idString])))));
    }).koin;

    var f =
        koin.getWithParams<AllFactory>(parameters: parametersOf([42, '42']));

    expect(42, f.myIntFactory.id);
    expect('42', f.myStringFactory.s);
  });
}
