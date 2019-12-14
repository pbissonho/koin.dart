import 'package:koin/koin.dart';
import 'package:koin/src/koin_application.dart';
import 'package:test/test.dart';
import '../test_extension/koin_application_ext.dart';
import '../classes.dart';

KoinApplication get koinApplication => KoinApplication();

void main() {
  test("allow overrides by type", () {
    var app = KoinApplication().module(module()
      ..single<ComponentInterface1>((s, p) => Component2())
      ..single<ComponentInterface1>((s, p) => Component1(), override: true));

    app.expectDefinitionsCount(1);
    expect(true, app.koin.get<ComponentInterface1>() is Component1);
  });

  test("allow overrides by name", () {
    var app = KoinApplication().module(module()
      ..single<ComponentInterface1>((s, p) => Component2(),
          qualifier: named("DEF"))
      ..single<ComponentInterface1>((s, p) => Component1(),
          override: true, qualifier: named("DEF")));

    app.expectDefinitionsCount(1);
    expect(true, app.koin.get<ComponentInterface1>(named("DEF")) is Component1);
  });
}
