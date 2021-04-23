import 'package:koin/koin.dart';
import 'package:koin/src/internal/exceptions.dart';
import 'package:test/test.dart';
import 'package:koin/internals.dart';
import '../components.dart';

class ScopeClass {}

void main() {
  var scopeKey = named('KEY');
  Koin? koin;

  setUp(() {
    koin = koinApplication((app) {
      app.module(Module()..scope<ScopeClass>((dsl) {}));
      app.module(Module()..scopeWithType(scopeKey, (s) {}));
    }).koin;
  });

  tearDown(() {
    koin?.close();
  });

  test('create a scope instance - with qualifier', () {
    var scopeId = 'myScope';
    var scope1 = koin?.createScopeWithQualifier(scopeId, scopeKey);
    var scope2 = koin?.getScope(scopeId);

    expect(scope1, scope2);
  });

  test('create a scope instance', () {
    var scopeId = 'myScope';
    var scope1 = koin?.createScope<ScopeClass>(scopeId);
    var scope2 = koin?.getScope(scopeId);

    expect(scope1, scope2);
  });

  test('shoud delete a scope instance', () {
    var scopeId = 'myScope';
    var scope1 = koin?.createScope<ScopeClass>(scopeId);
    koin?.deleteScope(scopeId);

    expect(scope1, isNotNull);
    var scope2 = koin?.getScopeOrNull(scopeId);
    expect(scope2, isNull);
  });

  test("can't find a non created scope instance", () {
    var scopeId = 'myScope';

    expect(() => koin?.getScope(scopeId),
        throwsA(isA<ScopeNotCreatedException>()));
  });

  test('create a scope instance', () {
    var scope1 = koin?.createScopeWithQualifier('myScope1', scopeKey);
    var scope2 = koin?.createScopeWithQualifier('myScope2', scopeKey);

    expect(scope1, isNot(scope2));
  });

  test("can't find a non created scope instance", () {
    var scopeId = 'myScope';

    expect(() => koin?.createScopeWithQualifier(scopeId, named('Test')),
        throwsA(isA<NoScopeDefFoundException>()));
  });

  test('create scope instance with scope def', () {
    var scope1 = koin?.createScopeWithQualifier('myScope', scopeKey);

    expect(scope1, isNotNull);
  });

  test("can't create a new scope if not closed", () {
    koin?.createScopeWithQualifier('myScope1', scopeKey);

    expect(() => koin?.createScopeWithQualifier('myScope1', scopeKey),
        throwsA(isA<ScopeAlreadyCreatedException>()));
  });

  test("can't get a closed scope", () {
    var scope = koin?.createScopeWithQualifier('myScope', scopeKey);
    scope?.close();

    expect(() => koin?.getScope('myScope'),
        throwsA(isA<ScopeNotCreatedException>()));
  });

  test('shoud create the scope', () {
    koin?.getOrCreateScope<ScopeClass>('myScope');

    var scope = koin?.getScope('myScope');

    expect(scope, isNotNull);
  });

  test('shoud create the scope - with qualifier', () {
    koin?.getOrCreateScopeQualifier('myScope', scopeKey);

    var scope = koin?.getScope('myScope');

    expect(scope, isNotNull);
  });

  test('shoud create the scope', () {
    koin?.createScopeWithQualifier('myScope', scopeKey);

    var scope = koin?.getScope('myScope');

    expect(scope, isNotNull);
  });

  test('reuse a closed scope', () {
    var scope = koin?.createScopeWithQualifier('myScope1', scopeKey);
    scope?.close();

    expect(
        () => scope?.get<ComponentA>(), throwsA(isA<ClosedScopeException>()));
  });

  test('find a scope by id', () {
    var scopeId = 'myScope';
    var scope1 = koin?.createScopeWithQualifier(scopeId, scopeKey);
    var id = scope1?.id;
    expect(scope1, koin?.getScope(id!));
  });

  test('scope callback', () {
    var scopeId = 'myScope';
    var scope1 = koin?.createScopeWithQualifier(scopeId, scopeKey);
    var closed = false;

    scope1?.registerCallback(ScopeCallbackTest(() {
      closed = true;
    }));

    scope1?.close();
    expect(closed, true);
  });

  test('scope to string', () {
    var scopeId = 'myScope';
    var scope1 = koin?.createScopeWithQualifier(scopeId, scopeKey);

    expect(scope1.toString(), '[${scope1?.id}]');
  });
}

class ScopeCallbackTest implements ScopeCallback {
  final void Function() onClose;

  ScopeCallbackTest(this.onClose);

  @override
  void onScopeClose() {
    onClose();
  }
}
