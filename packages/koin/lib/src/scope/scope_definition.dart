import '../definition/definition.dart';
import '../internal/exceptions.dart';
import '../qualifier.dart';
import 'package:kt_dart/kt.dart';

import '../definition/provider_definition.dart';
import '../definition/definitions.dart';

class ScopeDefinition {
  final Qualifier qualifier;
  final bool isRoot;
  final KtHashSet<ProviderDefinition> definitions = KtHashSet.empty();

  ScopeDefinition(this.qualifier, {this.isRoot});

  void save(ProviderDefinition beanDefinition, {bool forceOverride = false}) {
    if (definitions.contains(beanDefinition)) {
      if (beanDefinition.options.override || forceOverride) {
        definitions.remove(beanDefinition);
      } else {
        var current = definitions.firstOrNull((it) => it == beanDefinition);
        throw DefinitionOverrideException("""
      Definition '$beanDefinition' try to override existing definition. 
      Please use override option or check for definition '$current'""");
      }
    }
    definitions.add(beanDefinition);
  }

  void remove(ProviderDefinition beanDefinition) {
    definitions.remove(beanDefinition);
  }

  int size() => definitions.size;

  ProviderDefinition<T> saveNewDefinition<T>(
      T instance, Qualifier qualifier, List<Type> secondaryTypes,
      {bool override}) {
    var type = T;

    var found =
        definitions.firstOrNull((def) => def.isIt(type, qualifier, this));

    if (found != null) {
      if (override) {
        remove(found);
      } else {
        throw DefinitionOverrideException("""
Trying to override existing definition '$found' 
with new definition typed '$type'""");
      }
    }

    var secondaryTypes2;
    if (secondaryTypes != null) {
      secondaryTypes2 = secondaryTypes;
    } else {
      secondaryTypes2 = <Type>[];
    }
    //TODO
    var beanDefinition = Definitions.createSingle<T>(
        qualifier: qualifier,
        providerCreate: ProviderCreateDefinition((s) => instance),
        scopeDefinition: this,
        options: Options(isCreatedAtStart: false, override: override),
        secondaryTypes: secondaryTypes2);

    save(beanDefinition, forceOverride: override);
    return beanDefinition;
  }

  void unloadDefinitions(ScopeDefinition scopeDefinitionn) {
    scopeDefinitionn.definitions.forEach(definitions.remove);
  }

  @override
  int get hashCode => qualifier.hashCode ^ isRoot.hashCode;

  @override
  bool operator ==(other) {
    return other is ScopeDefinition &&
        other.qualifier == qualifier &&
        other.isRoot == isRoot;
  }

  ScopeDefinition copy() {
    var copy = ScopeDefinition(qualifier, isRoot: isRoot);
    copy.definitions.addAll(definitions);
    return copy;
  }

  static String rootScopeId = '-Root-';
  static Qualifier rootScopeQualifier = named(rootScopeId);
  static ScopeDefinition root() =>
      ScopeDefinition(rootScopeQualifier, isRoot: true);
}
