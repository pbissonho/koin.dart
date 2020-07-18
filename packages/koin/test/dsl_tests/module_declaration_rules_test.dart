import 'package:koin/koin.dart';
import 'package:koin/src/core/error/exceptions.dart';
import 'package:test/test.dart';

import '../components.dart';
import '../extensions/koin_application_ext.dart';

void main() {
  test("don't allow redeclaration", () {
    expect(() {
      koinApplication((app) {
        app.modules(
            [module()..single((s) => Simple())..single((s) => Simple())]);
      });
    }, throwsA((value) => value is DefinitionOverrideException));
  });

  test('allow redeclaration - different names', () {
    var app = koinApplication((app) {
      app.modules([
        module()
          ..single((s) => Simple(), qualifier: named('default'))
          ..single((s) => Simple(), qualifier: named('other'))
      ]);
    });

    app.expectDefinitionsCount(2);
  });

  test('allow qualifier redeclaration - same name', () {
    var koin = koinApplication((app) {
      app.modules([
        module()
          ..single((s) => ComponentA(), qualifier: named('default'))
          ..single((s) => ComponentB(s.get(named('default'))),
              qualifier: named('default'))
      ]);
    }).koin;

    var a = koin.get<ComponentA>(named('default'));
    var b = koin.get<ComponentB>(named('default'));
    expect(a, b.a);
  });

  test("don't allow redeclaration with different implementation", () {
    expect(() {
      koinApplication((app) {
        app.modules([
          module()
            ..single<ComponentInterface1>((s) => Component1())
            ..single<ComponentInterface1>((s) => Component2())
        ]);
      });
    }, throwsA((value) => value is DefinitionOverrideException));
  });
}
