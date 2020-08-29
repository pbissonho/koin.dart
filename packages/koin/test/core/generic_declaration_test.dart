import 'package:koin/koin.dart';
import 'package:koin/src/internal/exceptions.dart';
import 'package:test/test.dart';

void main() {
  var currentModule = module()
    ..single((s) => List<String>.of(['a string']),
        qualifier: named('strings'))
    ..single((s) => List<int>.of([42]), qualifier: named('ints'));

  test('declare and retrieve generic definitions', () {
    var koin = createKoin(currentModule);

    var aString = koin.get<List<String>>(named('strings'));
    expect('a string', aString[0]);

    var anInt = koin.get<List<int>>(named('ints'));
    expect(42, anInt[0]);
  });

  test('declare and not retrieve generic definitions', () {
    var koin = createKoin(currentModule);

    expect(() => koin.get<List<String>>(),
        throwsA((value) => value is NoBeanDefFoundException));
  });
}

Koin createKoin(Module module) {
  return koinApplication((app) {
    app.printLogger();
    app.module(module);
  }).koin;
}
