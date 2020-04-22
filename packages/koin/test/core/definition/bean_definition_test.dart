import 'package:koin/src/core/definition/bean_definition.dart';
import 'package:koin/src/core/qualifier.dart';
import 'package:test/test.dart';

class Service {}

class Definition {}

var qualifierDefinition = qualifier<Definition>();
var qualifierDefinitionTest = named('Definition');
var qualifierScope = qualifier<Definition>();

void main() {
  BeanDefinition<Service> beanDefinition;
  BeanDefinition<Service> beanDefinition2;
  BeanDefinition<Service> beanDefinition3;

  setUp(() {});

  test('equas operator', () {
    var equals = beanDefinition == beanDefinition2;
    var notEquals = (beanDefinition == beanDefinition3);

    expect(true, equals);
    expect(false, notEquals);
  });
}
