import 'package:koin/src/core/definition_parameters.dart';
import 'package:test/test.dart';

void main() {
  DefinitionParameters definitionParameters;
  List<Object> parameters;

  setUp(() {
    parameters = ["Buda", 22, "Juca", "5555"];
    definitionParameters = DefinitionParameters(parameters);
  });

  test("shoud get the first component", () {
    var object = definitionParameters.component1();
    var objectT = definitionParameters.getWhere<String>();

    expect(object, isNotNull);
    expect(object, isA<String>());
    expect(object, "Buda");
    expect(object, objectT);
  });

  test("shoud get the size", () {
    var size = definitionParameters.size();

    expect(size, 4);
  });

  test("verificar se está empty ou nao", () {
    var isEmpty = definitionParameters.isEmpty();
    var isNotEmpty = definitionParameters.isNotEmpty();

    expect(true, isNotEmpty);
    expect(false, isEmpty);
  });

  test("shoud return in a row", () {
    var objects = <Object>[];

    objects.add(definitionParameters.get(0));
    objects.add(definitionParameters.get(1));
    objects.add(definitionParameters.get(2));
    objects.add(definitionParameters.get(3));

    expect(objects, parameters);
  });
}
