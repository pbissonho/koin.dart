import 'package:koin/koin.dart';
import 'package:test/test.dart';

void main() {
  test('create a parameters holder', () {
    var myString = 'empty';
    var myInt = 42;
    var parameterHolder = parametersOf([myString, myInt]);

    expect(2, parameterHolder.size());
    expect(true, parameterHolder.isNotEmpty());
  });

  test('get parameters from a parameter holder', () {
    var myString = 'empty';
    var myInt = 42;
    var parameterHolder = parametersOf([myString, myInt]);

    var s = parameterHolder.getWhere<String>();
    var i = parameterHolder.getWhere<int>();

    expect(myString, s);
    expect(myInt, i);
  });
  test("can't create parameters more than max params", () {
    try {
      parametersOf([1, 2, 3, 4, 5, 6]);
      fail("Can't build more than ${DefinitionParameters.maxParams}");
    } catch (e) {}
  });
}
