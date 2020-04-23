import 'package:koin/src/core/definition/properties.dart';
import 'package:koin/src/core/error/exceptions.dart';
import 'package:test/test.dart';

void main() {
  test('get', () {
    var propeties = Properties();
    propeties.set('myString', 'String');

    expect(propeties.get('myString'), 'String');
  });

  test('get or null', () {
    var propeties = Properties();
    // propeties.set('myString', 'String');

    expect(propeties.getOrNull('myString'), null);
  });

  test('get and trowsn a exception', () {
    var propeties = Properties();
    // propeties.set('myString', 'String');
    expect(() => propeties.get('myString'),
        throwsA((value) => value is MissingPropertyException));
  });
}
