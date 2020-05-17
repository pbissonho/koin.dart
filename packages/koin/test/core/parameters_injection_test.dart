import 'package:koin/koin.dart';
import 'package:test/test.dart';

import '../components.dart';

void main() {
  test('can create a single with parameters', () {
    var app = koinApplication((app) {
      app.module(Module()..single<MySingle>((s, p) => MySingle(p.param1)));
    });

    var a = app.koin.getWithParams<MySingle>(parameters: parametersOf([42]));

    expect(a.id, 42);
  });

  test('can get a single created with parameters - no need of give it again',
      () {
    var app = koinApplication((app) {
      app.module(Module()..single<MySingle>((s, p) => MySingle(p.param1)));
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
      app.module(Module()..factory<MySingle>((s, p) => MySingle(p.param1)));
    });

    var a = app.koin.getWithParams<MySingle>(parameters: parametersOf([42]));
    var b = app.koin.getWithParams<MySingle>(parameters: parametersOf([43]));

    expect(a.id, 42);
    expect(b.id, 43);
  });

  test('chained factory injection', () {
    var koin = koinApplication((app) {
      app.module(Module()
        ..factory<MyIntFactory>((s, p) => MyIntFactory(p.param1))
        ..factory<MyStringFactory>((s, p) => MyStringFactory(p.param1))
        ..factory<AllFactory>((s, p) => AllFactory(
            s.getParams(parameters: parametersOf([p.param1])),
            s.getParams(parameters: parametersOf([p.param2])))));
    }).koin;

    var f = koin.getWithParams<AllFactory>(parameters: parametersOf([42, '42']));

    expect(42, f.myIntFactory.id);
    expect('42', f.myStringFactory.s);
  });
}
