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
    var first = definitionParameters.first();

    expect(object, isNotNull);
    expect(object, isA<String>());
    expect(object, "Buda");
    expect(object, first);
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

    objects.add(definitionParameters.get());
    objects.add(definitionParameters.get());
    objects.add(definitionParameters.get());
    objects.add(definitionParameters.get());

    expect(objects, parameters);
  });
}
