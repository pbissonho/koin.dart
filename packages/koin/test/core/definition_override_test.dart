import 'package:koin/koin.dart';
import 'package:test/test.dart';

import '../components.dart';
import '../dsl/koin_application_ext.dart';

void main() {
  test('allow overrides by type', () {
    var app = koinApplication((app) {
      app.module(module()
        ..single<ComponentInterface1>((s, p) => Component2())
        ..single<ComponentInterface1>((s, p) => Component1(), override: true));
    });


    app.expectDefinitionsCount(1);
    expect(true, app.koin.get<ComponentInterface1>() is Component1);
  });

  test('allow overrides by name', () {
    var app = KoinApplication().module(module()
      ..single<ComponentInterface1>((s, p) => Component2(),
          qualifier: named('DEF'))
      ..single<ComponentInterface1>((s, p) => Component1(),
          override: true, qualifier: named('DEF')));

    app.expectDefinitionsCount(1);
    expect(true, app.koin.get<ComponentInterface1>(named('DEF')) is Component1);
  });
}
