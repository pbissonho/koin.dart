import 'package:koin/src/core/definition_parameters.dart';
import 'package:koin/src/core/scope/scope.dart';
import 'package:koin/src/koin_dart.dart';

class InstanceRegistry {
  InstanceRegistry(Koin koin, Scope scope);

  void create(definitions) {}

  resolveInstance(String indexKeyCurrent, DefinitionParameters parameters) {}

  void saveDefinition(definition, {bool override}) {}

  void createEagerInstances() {}

  getAll(Type type) {}

  bind(Type primaryType, Type secondaryType, DefinitionParameters parameters) {}

  void close() {}

  void dropDefinition(definition) {}

  void createDefinition(definition) {}
}
