import 'package:koin/src/core/definition_parameters.dart';
import 'package:koin/src/core/error/exceptions.dart';
import 'package:test/test.dart';

void main() {
  DefinitionParameters definitionParameters;
  List<Object> parameters;

  setUp(() {
    parameters = ["Buda", 22, "Juca", "5555", 600];
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

    expect(size, 5);
  });

  test("verificar se está empty ou nao", () {
    var isEmpty = definitionParameters.isEmpty();
    var isNotEmpty = definitionParameters.isNotEmpty();

    expect(true, isNotEmpty);
    expect(false, isEmpty);
  });

  test("shoud return each value", () {
    var objects = <Object>[];

    objects.add(definitionParameters.get(0));
    objects.add(definitionParameters.get(1));
    objects.add(definitionParameters.get(2));
    objects.add(definitionParameters.get(3));
    objects.add(definitionParameters.get(4));
    var objectsX = <Object>[];

    objectsX.add(definitionParameters.component1());
    objectsX.add(definitionParameters.component2());
    objectsX.add(definitionParameters.component3());
    objectsX.add(definitionParameters.component4());
    objectsX.add(definitionParameters.component5());

    expect(objects, parameters);
    expect(objectsX, parameters);
  });

  test("parametersOf", () {
    var definitionParamateres = parametersOf(["Teste", "Test2"]);
    expect(definitionParamateres, isA<DefinitionParameters>());
    expect(definitionParamateres.size(), 2);
  });

  test("parametersOf", () {
    var definitionParamateres = emptyParametersHolder();
    expect(definitionParamateres, isA<DefinitionParameters>());
    expect(definitionParamateres.size(), 0);
  });

  test("create a definition with more 5 arguments", () {
    expect(() => DefinitionParameters(["1", "2", "3", "4", "5", "6"]),
        throwsA((value) => value is IllegalStateException));
  });
}
