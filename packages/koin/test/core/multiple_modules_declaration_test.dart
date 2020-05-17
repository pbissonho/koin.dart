import 'package:koin/koin.dart';
import 'package:test/test.dart';

import '../components.dart';
import '../extensions/koin_application_ext.dart';

void main() {
  test('run with DI with several modules', () {
    var app = koinApplication((app) {
      app.modules([
        Module()..single((s) => ComponentA()),
        Module()..single((s) => ComponentB(s.get()))
      ]);
    });

    app.expectDefinitionsCount(2);
  });

  test('resolve DI with several modules', () {
    var app = koinApplication((app) {
      app.modules([
        Module()..single((s) => ComponentA()),
        Module()..single((s) => ComponentB(s.get()))
      ]);
    });

    var koin = app.koin;

    var a = koin.get<ComponentA>();
    var b = koin.get<ComponentB>();

    var aInject = koin.inject<ComponentA>();
    var bInject = koin.inject<ComponentB>();

    expect(a, b.a);
    expect(aInject(), bInject().a);
  });
}
