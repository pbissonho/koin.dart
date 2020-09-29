import 'package:koin/koin.dart';
import 'package:test/test.dart';

void main() {
  test('generic type declaration', () {
    var koin = koinApplication((app) {
      app.modules([module()..single((s) => <String>[])]);
    }).koin;

    expect(koin.get<List<String>>(), isNotNull);
  });

  test('generic list types declaration', () {
    var koin = koinApplication((app) {
      app.modules([
        module()
          ..single((s) => <String>[], qualifier: named('strings'))
          ..single((s) => <int>[1, 2, 3], qualifier: named('ints'))
      ]);
    }).koin;

    var strings = koin.get<List<String>>(named('strings'));
    strings.add('value1');
    expect(1, koin.get<List<String>>(named('strings')).length);
    expect(3, koin.get<List<int>>(named('ints')).length);
  });
}
