import '../definition/definition_parameter.dart';
import '../internal/exceptions.dart';
import 'package:kt_dart/kt.dart';

import '../scope/scope.dart';

import '../koin_dart.dart';
import '../definition/bean_definition.dart';
import '../instance/instance_factory.dart';
import '../instance/instance_context.dart';
import '../instance/single_instance_factory.dart';
import '../instance/factory_instance_factory.dart';
import '../logger.dart';

// Creates and manages instance factorys.
class InstanceRegistry {
  final Koin koin;
  final Scope _scope;

  final _instances = KtHashMap<String, InstanceFactory>.empty();

  InstanceRegistry(this.koin, this._scope);

  void create(KtHashSet<BeanDefinition> definitions) {
    definitions.forEach((definition) {
      if (_scope.scopeDefinition.isRoot) {
        koin.logger.isAtdebug('- $definition', Level.debug);
      } else {
        koin.logger.isAtdebug('scope -> $definition', Level.debug);
      }
      saveDefinition(definition, override: false);
    });
  }

  void saveDefinition(BeanDefinition definition, {bool override}) {
    var defOverride = definition.options.override || override;
    var instanceFactory = createInstanceFactory(koin, definition);
    saveInstance(
        indexKey(definition.primaryType, definition.qualifier), instanceFactory,
        override: defOverride);

    definition.secondaryTypes.forEach((secondary) {
      if (defOverride) {
        saveInstance(indexKey(secondary, definition.qualifier), instanceFactory,
            override: defOverride);
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
      case Kind.single:
        instance = SingleInstanceFactory(koin, definition);
        break;
      case Kind.factory:
        instance = FactoryInstanceFactory(koin, definition);
        break;
    }

    return instance;
  }

  void saveInstance(String key, InstanceFactory factory, {bool override}) {
    if (_instances.containsKey(key) && !override) {
      throw IllegalStateException(
          "InstanceRegistry already contains index '$key'");
    } else {
      _instances[key] = factory;
    }
  }

  void saveInstanceIfPossible(String key, InstanceFactory factory) {
    if (!_instances.containsKey(key)) {
      _instances[key] = factory;
    }
  }

  T resolveInstance<T>(String indexKey, DefinitionParameter parameters) {
    var instance =
        _instances[indexKey]?.get(defaultInstanceContext(parameters)) as T;
    return instance;
  }

  InstanceContext defaultInstanceContext(
      DefinitionParameter definitionParameter) {
    return InstanceContext(
        koin: koin, scope: _scope, definitionParameter: definitionParameter);
  }

  void close() {
    _instances.values.forEach((it) => it.dispose());
    _instances.clear();
  }

  void createEagerInstances() {
    _instances.values
        .filterIsInstance<SingleInstanceFactory>()
        .filter((instance) => instance.beanDefinition.options.isCreatedAtStart)
        .forEach((instance) =>
            instance.get(InstanceContext(koin: koin, scope: _scope)));
  }

  List<T> getAllByType<T>(Type type) {
    var instancesSet = _instances.values.toSet();

    var potencialKeys = instancesSet
        .filter((instance) => instance.beanDefinition.hasType(type));

    return potencialKeys
        .map((instance) => instance.get(defaultInstanceContext(null)) as T)
        .asList();
  }

  KtList<InstanceFactory> getAllFactoryAsList() => _instances.values.toList();

  S bind<S>(Type primaryType, Type secondaryType,
      DefinitionParameter definitionParameter) {
    var instance = _instances.values.firstOrNull((instance) {
      final canBind =
          instance.beanDefinition.canBind(primaryType, secondaryType);
      return canBind;
    });

    return instance?.get(defaultInstanceContext(definitionParameter)) as S;
  }

  void disposeDefinition(BeanDefinition definition) {
    var ids = _instances
        .filter((it) => it.value.beanDefinition == definition)
        .map((it) => it.key);
    ids.forEach(_instances.remove);
  }

  void createDefinition(BeanDefinition definition) {
    saveDefinition(definition, override: false);
  }
}
