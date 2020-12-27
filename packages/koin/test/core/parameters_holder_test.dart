import 'package:koin/internals.dart';
import 'package:test/test.dart';

void main() {
  late Parameter definitionParameter;

  setUp(() {
    definitionParameter = Parameter(50);
  });

  test('shoud get the  component', () {
    var object = definitionParameter.parameter;
    expect(object, isNotNull);
  });

  test('shoud get a num param', () {
    definitionParameter = emptyParameter();
    var object = definitionParameter.parameter;
    expect(object, isNull);
  });
}
