import 'package:koin/src/core/definition/properties.dart';
import 'package:koin/src/core/error/exceptions.dart';
import 'package:test/test.dart';

void main() {
  test('can store & get an attribute value', () {
    var propeties = Properties();
    propeties.set('myString', 'String');

    expect(propeties.get('myString'), 'String');
  });

  test('attribute empty - no value', () {
    var propeties = Properties();

    expect(propeties.getOrNull('myKey'), null);
  });

  test('attribute value overwrite', () {
    var propeties = Properties();

    propeties.set('myKey', 'myString');
    propeties.set('myKey', 'myString2');

    var string = propeties.get<String>('myKey');

    expect('myString2', string);
  });

  test('get and trown a exception', () {
    var propeties = Properties();
    // propeties.set('myString', 'String');
    expect(() => propeties.get('myString'),
        throwsA((value) => value is MissingPropertyException));
  });
}
