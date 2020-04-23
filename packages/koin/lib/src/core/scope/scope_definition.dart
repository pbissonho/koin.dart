import 'package:equatable/equatable.dart';
import 'package:koin/src/core/error/exceptions.dart';
import 'package:koin/src/core/qualifier.dart';
import 'package:kt_dart/kt.dart';

import '../definition/bean_definition.dart';
import '../definition/definitions.dart';
import '../definition/options.dart';

class ScopeDefinition extends Equatable {
  final Qualifier qualifier;
  final bool isRoot;
  KtHashSet<BeanDefinition> definitions = KtHashSet.empty();

  ScopeDefinition(this.qualifier, this.isRoot) {}

  void save(BeanDefinition beanDefinition, [bool forceOverride = false]) {
    if (definitions.contains(beanDefinition)) {
      if (beanDefinition.options.override || forceOverride) {
        definitions.remove(beanDefinition);
      } else {
        var current = definitions.firstOrNull((it) => it == beanDefinition);
        throw DefinitionOverrideException(
            "Definition '$beanDefinition' try to override existing definition. Please use override option or check for definition '$current'");
      }
    }
    definitions.add(beanDefinition);
  }

  void remove(BeanDefinition beanDefinition) {
    definitions.remove(beanDefinition);
  }

  int size() => definitions.size;

  BeanDefinition<T> saveNewDefinition<T>(T instance, Qualifier qualifier,
      List<Type> secondaryTypes, bool override) {
    var type = T;

    var found =
        definitions.firstOrNull((def) => def.isIt(type, qualifier, this));

    if (found != null) {
      if (override) {
        remove(found);
      } else {
        throw DefinitionOverrideException(
            "Trying to override existing definition '$found' with new definition typed '$type'");
      }
    }

    var secondaryTypes2;
    if (secondaryTypes != null) {
      secondaryTypes2 = secondaryTypes;
    } else {
      secondaryTypes2 = <Type>[];
    }

    var beanDefinition = Definitions.createSingle<T>(
        qualifier: qualifier,
        definition: (s, p) => instance,
        scopeDefinition: this,
        options: Options(isCreatedAtStart: false, override: override),
        secondaryTypes: secondaryTypes2);

    save(beanDefinition, override);
    return beanDefinition;
  }

  void unloadDefinitions(ScopeDefinition scopeDefinitionn) {
    scopeDefinitionn.definitions.forEach((definition) {
      definitions.remove(definition);
    });
  }

  @override
  List<Object> get props => [qualifier, isRoot];

  ScopeDefinition copy() {
    var copy = ScopeDefinition(qualifier, isRoot);
    copy.definitions.addAll(definitions);
    return copy;
  }

  static var ROOT_SCOPE_ID = "-Root-";
  static var ROOT_SCOPE_QUALIFIER = named(ROOT_SCOPE_ID);
  static rootDefinition() => ScopeDefinition(ROOT_SCOPE_QUALIFIER, true);
}
