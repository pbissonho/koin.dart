import 'package:koin/src/core/definition_parameters.dart';
import 'package:koin/src/core/error/error.dart';
import 'package:koin/src/core/scope/scope.dart';
import 'package:koin/src/koin_dart.dart';
import 'package:kt_dart/kt.dart';

import '../definition/bean_definition.dart';
import '../instance/instance_factory.dart';
import '../instance/instance_context.dart';
import '../instance/single_instance_factory.dart';
import '../instance/factory_instance_factory.dart';
import '../logger.dart';

class InstanceRegistry {
  Koin koin;
  Scope scope;

  var instances = KtHashMap<String, InstanceFactory>.empty();

  InstanceRegistry(this.koin, this.scope);

  void create(KtHashSet<BeanDefinition> definitions) {
    definitions.forEach((definition) {
      if (koin.logger.isAt(Level.debug)) {
        if (scope.scopeDefinition.isRoot) {
          koin.logger.debug('- $definition');
        } else {
          koin.logger.debug('scope -> $definition');
        }
      }
      saveDefinition(definition, override: false);
    });
  }

  void saveDefinition(BeanDefinition definition, {bool override}) {
    var defOverride = definition.options.override || override;
    var instanceFactory = createInstanceFactory(koin, definition);
    saveInstance(indexKey(definition.primaryType, definition.qualifier),
        instanceFactory, defOverride);

    definition.secondaryTypes.forEach((secondary) {
      if (defOverride) {
        saveInstance(indexKey(secondary, definition.qualifier), instanceFactory,
            defOverride);
      } else {
        saveInstanceIfPossible(
            indexKey(secondary, definition.qualifier), instanceFactory);
      }
    });
  }

  InstanceFactory createInstanceFactory(
    Koin koin,
    BeanDefinition definition,
  ) {
    InstanceFactory instance;

    switch (definition.kind) {
      case Kind.Single:
        instance = SingleInstanceFactory(koin, definition);
        break;
      case Kind.Factory:
        instance = FactoryInstanceFactory(koin, definition);
        break;
    }

    return instance;
  }

  void saveInstance(String key, InstanceFactory factory, bool override) {
    if (instances.containsKey(key) && !override) {
      error("InstanceRegistry already contains index '$key'");
    } else {
      instances[key] = factory;
    }
  }

  void saveInstanceIfPossible(String key, InstanceFactory factory) {
    if (!instances.containsKey(key)) {
      instances[key] = factory;
    }
  }

  T resolveInstance<T>(String indexKey, DefinitionParameters parameters) {
    return instances[indexKey]?.get(defaultInstanceContext(parameters)) as T;
  }

  InstanceContext defaultInstanceContext(DefinitionParameters parameters) {
    return InstanceContext(koin: koin, scope: scope, parameters: parameters);
  }

  void close() {
    instances.values.forEach((it) => it.drop());
    instances.clear();
  }

  void createEagerInstances() {
    instances.values
        .filterIsInstance<SingleInstanceFactory>()
        .filter((instance) => instance.beanDefinition.options.isCreatedAtStart)
        .forEach((instance) =>
            instance.get(InstanceContext(koin: koin, scope: scope)));
  }

  List<T> getAll<T>(Type type) {
    var instancesSet = instances.values.toSet();

    var potencialKeys = instancesSet
        .filter((instance) => instance.beanDefinition.hasType(type));

    return potencialKeys
        .map((instance) => instance.get(defaultInstanceContext(null)) as T)
        .asList();
  }

  S bind<S>(
      Type primaryType, Type secondaryType, DefinitionParameters parameters) {
    var instance = instances.values.firstOrNull((instance) {
      return instance.beanDefinition.canBind(primaryType, secondaryType);
    });

    return instance.get(defaultInstanceContext(parameters)) as S;
  }

  void dropDefinition(BeanDefinition definition) {
    var ids = instances
        .filter((it) => it.value.beanDefinition == definition)
        .map((it) => it.key);
    ids.forEach((id) => instances.remove(id));
  }

  void createDefinition(definition) {
    saveDefinition(definition, override: false);
  }
}
