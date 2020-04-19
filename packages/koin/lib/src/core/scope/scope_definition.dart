import 'package:equatable/equatable.dart';
import 'package:koin/src/core/error/exceptions.dart';
import 'package:koin/src/core/qualifier.dart';

import '../definition/bean_definition.dart';

class ScopeDefinition extends Equatable {
  final Qualifier qualifier;
  final bool isRoot;
  final Set<BeanDefinition> definitions = Set<BeanDefinition>();

  ScopeDefinition(this.qualifier, this.isRoot);

  void remove(BeanDefinition beanDefinition) {
    definitions.remove(beanDefinition);
  }

  int size() => definitions.length;

  BeanDefinition<T> saveNewDefinition<T>(T instance, Qualifier qualifier,
      List<Type> secondaryTypes, bool override) {
    var type = T;

    var found =
        definitions.firstWhere((def) => def.isIt(type, qualifier, this));

    if (found != null) {
      if (override) {
        remove(found);
      } else {
        throw DefinitionOverrideException(
            "Trying to override existing definition '$found' with new definition typed '$type'");
      }
    }

    /// var beanDefinition = Definition.createSingle(type, qualifier, instance, this, Options());

    ///save();
    ///return beanDefinition;
  }

  void unloadDefinitions(ScopeDefinition scopeDefinitionn) {
    scopeDefinitionn.definitions.forEach((definition) {
      definitions.remove(definition);
    });
  }

  @override
  List<Object> get props => [qualifier, isRoot];

  ScopeDefinition copy() {}

  void save(BeanDefinition it) {}

  static var ROOT_SCOPE_ID = "-Root-";
  static var ROOT_SCOPE_QUALIFIER = named(ROOT_SCOPE_ID);
  static rootDefinition() => ScopeDefinition(ROOT_SCOPE_QUALIFIER, true);
}
