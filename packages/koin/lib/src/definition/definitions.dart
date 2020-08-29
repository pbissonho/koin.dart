import '../qualifier.dart';
import 'bean_definition.dart';
import '../scope/scope_definition.dart';
import '../definition/options.dart';
import 'definition.dart';

class Definitions {
  static BeanDefinition<T> saveSingle<T>(
      Qualifier qualifier,
      DefinitionBase<T> definition,
      ScopeDefinition scopeDefinition,
      Options options) {
    var beanDefinition = createSingle<T>(
        qualifier: qualifier,
        definition: definition,
        scopeDefinition: scopeDefinition,
        options: options);
    scopeDefinition.save(beanDefinition);
    return beanDefinition;
  }

  static BeanDefinition<T> createSingle<T>(
      {Qualifier qualifier,
      DefinitionBase<T> definition,
      ScopeDefinition scopeDefinition,
      Options options,
      List<Type> secondaryTypes}) {
    return BeanDefinition<T>(
        scopeDefinition: scopeDefinition,
        primaryType: T,
        qualifier: qualifier,
        definition: definition,
        kind: Kind.single,
        options: options,
        secondaryTypes: secondaryTypes);
  }

  static BeanDefinition<T> createFactory<T>(
      {Qualifier qualifier,
      DefinitionBase<T> definition,
      ScopeDefinition scopeDefinition,
      Options options,
      List<Type> secondaryTypes}) {
    return BeanDefinition<T>(
        scopeDefinition: scopeDefinition,
        primaryType: T,
        qualifier: qualifier,
        definition: definition,
        kind: Kind.factory,
        options: options,
        secondaryTypes: secondaryTypes);
  }

  static BeanDefinition<T> saveFactory<T>(
      Qualifier qualifier,
      DefinitionBase<T> definition,
      ScopeDefinition scopeDefinition,
      Options options) {
    var beanDefinition = createFactory<T>(
        qualifier: qualifier,
        definition: definition,
        scopeDefinition: scopeDefinition,
        options: options);
    scopeDefinition.save(beanDefinition);
    return beanDefinition;
  }
}
