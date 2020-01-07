import 'package:koin/koin.dart';
import 'package:koin_test/src/check/check_module_dsl.dart';

extension KoinExtension on Koin {
  void checkModules(CheckParameters parametersDefinition) {
    checkScopedDefinitions(parametersDefinition.creators);
    checkScopedDefinitions(parametersDefinition.creators);
  }

  void checkScopedDefinitions(
      Map<CheckedComponent, DefinitionParameters> allParameters) {
    scopeRegistry.getScopeSets().forEach((value) {
      var scope = createScope(value.qualifier.toString(), value.qualifier);
      value.definitions.forEach((definition) {
        var parameters = allParameters[
            CheckedComponent(definition.qualifier, definition.primaryType)];
        scope.getWithType(
            definition.primaryType, definition.qualifier, parameters);
      });
    });
  }

  void checkMainDefinitions(
      Map<CheckedComponent, DefinitionParameters> allParameters) {
    rootScope.beanRegistry.getAllDefinitions().forEach((definition) {
      var parameters = allParameters[
          CheckedComponent(definition.qualifier, definition.primaryType)];

      if (parameters == null) {
        parameters = parametersOf([]);
      }

      getWithType(definition.primaryType, definition.qualifier, parameters);
    });
  }
}
