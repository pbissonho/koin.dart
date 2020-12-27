import '../qualifier.dart';
import '../scope/scope_definition.dart';
import 'definition.dart';
import 'provider_definition.dart';

class Definitions {
  static ProviderDefinition<T> saveSingle<T>(
      Qualifier? qualifier,
      ProviderCreateBase<T> providerCreate,
      ScopeDefinition scopeDefinition,
      Options options) {
    var beanDefinition = createSingle<T>(
        qualifier: qualifier,
        providerCreate: providerCreate,
        scopeDefinition: scopeDefinition,
        options: options,
        secondaryTypes: []);
    scopeDefinition.save(beanDefinition);
    return beanDefinition;
  }

  static ProviderDefinition<T> createSingle<T>(
      {Qualifier? qualifier,
      required ProviderCreateBase<T> providerCreate,
      required ScopeDefinition scopeDefinition,
      required Options options,
      required List<Type> secondaryTypes}) {
    return ProviderDefinition<T>(
        scopeDefinition: scopeDefinition,
        primaryType: T,
        qualifier: qualifier,
        definition: providerCreate,
        kind: Kind.single,
        options: options,
        secondaryTypes: secondaryTypes);
  }

  static ProviderDefinition<T> createFactory<T>(
      {Qualifier? qualifier,
      required ProviderCreateBase<T> providerCreate,
      required ScopeDefinition scopeDefinition,
      required Options options,
      required List<Type> secondaryTypes}) {
    return ProviderDefinition<T>(
        scopeDefinition: scopeDefinition,
        primaryType: T,
        qualifier: qualifier,
        definition: providerCreate,
        kind: Kind.factory,
        options: options,
        secondaryTypes: secondaryTypes);
  }

  static ProviderDefinition<T> saveFactory<T>(
      Qualifier? qualifier,
      ProviderCreateBase<T> providerCreate,
      ScopeDefinition scopeDefinition,
      Options options) {
    var beanDefinition = createFactory<T>(
        qualifier: qualifier,
        providerCreate: providerCreate,
        scopeDefinition: scopeDefinition,
        options: options,
        secondaryTypes: []);
    scopeDefinition.save(beanDefinition);
    return beanDefinition;
  }
}
