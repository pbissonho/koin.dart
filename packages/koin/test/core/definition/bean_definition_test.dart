import 'package:koin/src/core/definition/bean_definition.dart';
import 'package:koin/src/core/instance/factory_definition_instance.dart';
import 'package:koin/src/core/instance/scope_definition_instance.dart';
import 'package:koin/src/core/instance/singleton_definition_instance.dart';
import 'package:koin/src/core/qualifier.dart';
import 'package:test/test.dart';

class Service {}

class Definition {}

var qualifierDefinition = qualifier(Definition);
var qualifierDefinitionTest = named("Definition");
var qualifierScope = qualifier(Definition);

void main() {
  BeanDefinition<Service> beanDefinition;
  BeanDefinition<Service> beanDefinition2;
  BeanDefinition<Service> beanDefinition3;
  setUp(() {
    beanDefinition2 = BeanDefinition<Service>(
        qualifierDefinition, qualifierScope, Kind.Single, (s, p) => Service());

    beanDefinition = BeanDefinition<Service>(
        qualifierDefinition, qualifierScope, Kind.Single, (s, p) => Service());

    beanDefinition3 = BeanDefinition<Service>(qualifierDefinitionTest,
        qualifierScope, Kind.Single, (s, p) => Service());
  });

  test("equas operator", () {
    var equals = beanDefinition == beanDefinition2;
    var notEquals = (beanDefinition == beanDefinition3);

    expect(true, equals);
    expect(false, notEquals);
  });
  test("create instance holder", () {
    BeanDefinition<Service> beanDefinitionSingle = BeanDefinition.createSingle(
        qualifierDefinition, qualifierScope, (s, p) => Service());

    BeanDefinition<Service> beanDefinitionFactory =
        BeanDefinition.createFactory(
            qualifierDefinition, qualifierScope, (s, p) => Service());

    BeanDefinition<Service> beanDefinitionScoped = BeanDefinition.createScoped(
        qualifierDefinition, qualifierScope, (s, p) => Service());

    beanDefinitionSingle.createInstanceHolder();
    var single = beanDefinitionSingle.intance;
    expect(single, isNotNull);
    expect(single, isA<SingleDefinitionInstance>());

    beanDefinitionFactory.createInstanceHolder();
    var factory = beanDefinitionFactory.intance;
    expect(factory, isNotNull);
    expect(factory, isA<FactoryDefinitionInstance>());

    beanDefinitionScoped.createInstanceHolder();
    var scope = beanDefinitionScoped.intance;
    expect(scope, isNotNull);
    expect(scope, isA<ScopeDefinitionInstance>());
  });
}
