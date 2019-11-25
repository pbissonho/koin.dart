import 'package:koin/src/core/definition/bean_definition.dart';
import 'package:koin/src/core/instance/definition_instance.dart';
import 'package:koin/src/core/instance/factory_definition_instance.dart';
import 'package:koin/src/core/instance/singleton_definition_instance.dart';
import 'package:koin/src/core/qualifier.dart';
import 'package:test/test.dart';

class Service {}

class Definition {}

var qualifierDefinition = qualifier(Definition);
var qualifierDefinitionTest = named("Definition");
var qualifierScope = qualifier(Definition);

void main() {
  test("Create FactoryDefinitionInstance ", () {
    BeanDefinition<Service> beanDefinitionSingle = BeanDefinition.createFactory(
        qualifierDefinition, qualifierScope, (s, p) => Service());
    var factoryInstance = FactoryDefinitionInstance(beanDefinitionSingle);

    expect(false, factoryInstance.isCreated(InstanceContext()));
    var result1 = factoryInstance.get(InstanceContext());
    var result2 = factoryInstance.get(InstanceContext());

    expect(result1, isNotNull);
    expect(result1, isA<Service>());
    expect(true, result1 != result2);
    expect(false, factoryInstance.isCreated(InstanceContext()));
  });

  test("Create SingleDefinitionInstance ", () {
    BeanDefinition<Service> beanDefinitionSingle = BeanDefinition.createSingle(
        qualifierDefinition, qualifierScope, (s, p) => Service());
    var factoryInstance = SingleDefinitionInstance(beanDefinitionSingle);

    expect(false, factoryInstance.isCreated(InstanceContext()));
    var result1 = factoryInstance.get(InstanceContext());
    var result2 = factoryInstance.get(InstanceContext());

    expect(result1, isNotNull);
    expect(result1, isA<Service>());
    expect(true, result1 == result2);
    expect(true, factoryInstance.isCreated(InstanceContext()));
  });
}
