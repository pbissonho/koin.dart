import '../scope/scope.dart';
import 'definition_parameter.dart';

typedef DefinitionFunction<T> = T Function(Scope scope);

typedef DefinitionFunctionWithParam<T, A> = T Function(Scope scope, A param);

abstract class DefinitionBase<T> {
  T create(DefinitionParameter parameters, Scope scope);
}

class Definition<T> implements DefinitionBase<T> {
  final DefinitionFunction<T> definition;

  Definition(this.definition);

  @override
  T create(DefinitionParameter parameters, Scope scope) {
    return definition(scope);
  }
}

class DefinitionWithParam<T, A> implements DefinitionBase<T> {
  final DefinitionFunctionWithParam<T, A> definition;

  DefinitionWithParam(this.definition);

  @override
  T create(DefinitionParameter parameters, Scope scope) {
    return definition(scope, parameters.get());
  }
}
