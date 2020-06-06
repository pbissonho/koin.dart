import 'package:koin/koin.dart';
import 'package:koin/src/core/error/exceptions.dart';
import 'package:test/test.dart';

void main() {
  DefinitionParameters definitionParameters;
  List<Object> parameters;

  setUp(() {
    parameters = ['Buda', 22, 'Juca', '5555', 600];
    definitionParameters = DefinitionParameters(parameters);
  });

  test('shoud get the first component', () {
    var object = definitionParameters.component1;
    var objectT = definitionParameters.getWhere<String>();

    expect(object, isNotNull);
    expect(object, isA<String>());
    expect(object, 'Buda');
    expect(object, objectT);
  });

  test('shoud get the size', () {
    var size = definitionParameters.size();

    expect(size, 5);
  });

  test('shoud be not empty', () {
    var isEmpty = definitionParameters.isEmpty();
    var isNotEmpty = definitionParameters.isNotEmpty();

    expect(true, isNotEmpty);
    expect(false, isEmpty);
  });

  test('shoud return each value', () {
    var objects = <Object>[];

    objects.add(definitionParameters.get(0));
    objects.add(definitionParameters.get(1));
    objects.add(definitionParameters.get(2));
    objects.add(definitionParameters.get(3));
    objects.add(definitionParameters.get(4));

    var components = <Object>[];

    components.add(definitionParameters.component1);
    components.add(definitionParameters.component2);
    components.add(definitionParameters.component3);
    components.add(definitionParameters.component4);
    components.add(definitionParameters.component5);

    var params = <Object>[];

    params.add(definitionParameters.param1);
    params.add(definitionParameters.param2);
    params.add(definitionParameters.param3);
    params.add(definitionParameters.param4);
    params.add(definitionParameters.param5);

    expect(objects, parameters);
    expect(components, parameters);
    expect(params, parameters);
  });

  test('parametersOf', () {
    var definitionParamateres = parametersOf(['Teste', 'Test2']);
    expect(definitionParamateres, isA<DefinitionParameters>());
    expect(definitionParamateres.size(), 2);
  });

  test('parametersOf', () {
    var definitionParamateres = emptyParametersHolder();
    expect(definitionParamateres, isA<DefinitionParameters>());
    expect(definitionParamateres.size(), 0);
  });

  test('create a definition with more 5 arguments', () {
    expect(() => DefinitionParameters(['1', '2', '3', '4', '5', '6']),
        throwsA((value) => value is DefinitionParameterException));
  });

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

  test('shoud get a emptyParametersHolder from a parametersOf', () {
    var parameterHolder = parametersOf(null);
    expect(parameterHolder.size(), 0);
  });

  test("can't create parameters more than max params", () {
    expect(() => parametersOf([1, 2, 3, 4, 5, 6]),
        throwsA(isA<DefinitionParameterException>()));
  });

  test("can't get parameters out of index", () {
    expect(() => parametersOf([1, 2, 3, 4, null]).elementAt(4),
        throwsA(isA<DefinitionParameterException>()));
  });
}
