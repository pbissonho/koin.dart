import 'package:koin/koin.dart';
import 'package:koin/src/core/error/exceptions.dart';
import 'package:koin/src/core/scope/scope_callback.dart';
import 'package:test/test.dart';

import '../components.dart';

void main() {
  var scopeKey = named('KEY');
  Koin koin;

  setUp(() {
    koin = koinApplication((app) {
      app.module(Module()..scopeWithType(scopeKey, (s) {}));
    }).koin;
  });

  tearDown(() {
    koin.close();
  });

  test('create a scope instance', () {
    var scopeId = 'myScope';
    var scope1 = koin.createScope(scopeId, scopeKey);
    var scope2 = koin.getScope(scopeId);

    expect(scope1, scope2);
  });

  test("can't find a non created scope instance", () {
    var scopeId = 'myScope';

    expect(
        () => koin.getScope(scopeId), throwsA(isA<ScopeNotCreatedException>()));
  });

  test('create a scope instance', () {
    var scope1 = koin.createScope('myScope1', scopeKey);
    var scope2 = koin.createScope('myScope2', scopeKey);

    expect(scope1, isNot(scope2));
  });

  test("can't find a non created scope instance", () {
    var scopeId = 'myScope';

    expect(() => koin.createScope(scopeId, named('Test')),
        throwsA(isA<NoScopeDefFoundException>()));
  });

  test('create scope instance with scope def', () {
    var scope1 = koin.createScope('myScope', scopeKey);

    expect(scope1, isNotNull);
  });

  test("can't create a new scope if not closed", () {
    koin.createScope('myScope1', scopeKey);

    expect(() => koin.createScope('myScope1', scopeKey),
        throwsA(isA<ScopeAlreadyCreatedException>()));
  });

  test("can't get a closed scope", () {
    var scope = koin.createScope('myScope', scopeKey);
    scope.close();

    expect(() => koin.getScope('myScope'),
        throwsA(isA<ScopeNotCreatedException>()));
  });

  test('reuse a closed scope', () {
    var scope = koin.createScope('myScope1', scopeKey);
    scope.close();

    expect(() => scope.get<ComponentA>(), throwsA(isA<ClosedScopeException>()));
  });

  test('find a scope by id', () {
    var scopeId = 'myScope';
    var scope1 = koin.createScope(scopeId, scopeKey);
    expect(scope1, koin.getScope(scope1.id));
  });

  test('scope callback', () {
    var scopeId = 'myScope';
    var scope1 = koin.createScope(scopeId, scopeKey);
    var closed = false;

    scope1.registerCallback(ScopeCallbackTest(() {
      closed = true;
    }));

    scope1.close();
    expect(closed, true);
  });
}

class ScopeCallbackTest implements ScopeCallback {
  final void Function() onClose;

  ScopeCallbackTest(this.onClose);

  @override
  void onScopeClose(Scope scope) {
    onClose();
  }
}
