import 'package:koin/internal.dart';
import 'package:test/test.dart';

void main() {
  DefinitionParameter definitionParameter;

  setUp(() {
    definitionParameter = DefinitionParameter(50);
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
