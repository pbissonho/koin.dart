import 'package:koin/koin.dart';
import 'package:koin/src/core/exceptions.dart';
import 'package:test/test.dart';

import '../components.dart';

class ScopeType {}

void main() {
  test("can't get scoped dependency without scope", () {
    var koin = koinApplication((app) {
      app.printLogger(level: Level.debug);
      app.module(module()
        ..scope<ScopeType>((s) {
          s.scoped((s) => ComponentA());
        }));
    }).koin;

    expect(() => koin.get<ComponentA>(),
        throwsA((value) => value is NoBeanDefFoundException));
  });

  test("can't get scoped dependency without scope from single", () {
    var koin = koinApplication((app) {
      app.printLogger(level: Level.debug);
      app.module(module()
        ..single((s) => ComponentB(s.get()))
        ..scope<ScopeType>((s) {
          s.scoped((s) => ComponentA());
        }));
    }).koin;

    expect(() => koin.get<ComponentA>(),
        throwsA((value) => value is NoBeanDefFoundException));
  });

  test('get scoped dependency without scope from single', () {
    var scopeId = 'MY_SCOPE_ID';

    var koin = koinApplication((app) {
      app.printLogger(level: Level.debug);
      app.module(module()
        ..single((s) => ComponentB(s.getScope(scopeId).get()))
        ..scope<ScopeType>((s) {
          s.scoped((s) => ComponentA());
        }));
    }).koin;

    var scope = koin.createScopeWithQualifier(scopeId, named<ScopeType>());

    expect(koin.get<ComponentB>().a, scope.get<ComponentA>());
  });
}
