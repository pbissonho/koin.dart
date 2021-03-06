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

  ScopeDefinition(this.qualifier, {this.isRoot = false});

  void save(ProviderDefinition beanDefinition, {bool forceOverride = false}) {
    if (definitions.contains(beanDefinition)) {
      if (beanDefinition.options.override || forceOverride) {
        definitions.remove(beanDefinition);
      } else {
        final current = definitions.firstOrNull((it) => it == beanDefinition);
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
      T instance, Qualifier? qualifier, List<Type> secondaryTypes,
      {bool override = false}) {
    final type = T;

    final found =
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

    //TODO
    final beanDefinition = Definitions.createSingle<T>(
        qualifier: qualifier,
        providerCreate: ProviderCreateDefinition((s) => instance),
        scopeDefinition: this,
        options: Options(isCreatedAtStart: false, override: override),
        secondaryTypes: secondaryTypes);

    save(beanDefinition, forceOverride: override);
    return beanDefinition;
  }

  void unloadDefinitions(ScopeDefinition scopeDefinitionn) {
    scopeDefinitionn.definitions.forEach(definitions.remove);
  }

  @override
  int get hashCode => qualifier.hashCode ^ isRoot.hashCode;

  @override
  bool operator ==(Object other) {
    return other is ScopeDefinition &&
        other.qualifier == qualifier &&
        other.isRoot == isRoot;
  }

  ScopeDefinition copy() {
    final copy = ScopeDefinition(qualifier, isRoot: isRoot);
    copy.definitions.addAll(definitions);
    return copy;
  }

  static String rootScopeId = '-Root-';
  static Qualifier rootScopeQualifier = named(rootScopeId);
  static ScopeDefinition root() =>
      ScopeDefinition(rootScopeQualifier, isRoot: true);
}
