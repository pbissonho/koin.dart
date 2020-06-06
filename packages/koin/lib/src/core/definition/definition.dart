import '../definition_parameters.dart';
import '../scope/scope.dart';

typedef DefinitionFunction<T> = T Function(Scope scope);

typedef DefinitionFunction1<T, A> = T Function(Scope scope, A param);

typedef DefinitionFunction2<T, A, B> = T Function(
    Scope scope, A paraA, B paramB);

typedef DefinitionFunction3<T, A, B, C> = T Function(
    Scope scope, A paramA, B paramB, C paramC);

abstract class DefinitionBase<T> {
  DefinitionBase();

  T create(DefinitionParameters parameters, Scope scope);
}

class DefinitionX<T> implements DefinitionBase<T> {
  final DefinitionFunction<T> definition;

  DefinitionX(this.definition);

  @override
  T create(DefinitionParameters parameters, Scope scope) {
    return definition(scope);
  }
}

class Definition1<T, A> implements DefinitionBase<T> {
  final DefinitionFunction1<T, A> definition;

  Definition1(this.definition);

  @override
  T create(DefinitionParameters parameters, Scope scope) {
    return definition(scope, parameters.param1);
  }
}

class Definition2<T, A, B> implements DefinitionBase<T> {
  final DefinitionFunction2<T, A, B> definition;

  Definition2(this.definition);

  @override
  T create(DefinitionParameters parameters, Scope scope) {
    return definition(scope, parameters.param1, parameters.param2);
  }
}

class Definition3<T, A, B, C> implements DefinitionBase<T> {
  final DefinitionFunction3<T, A, B, C> definition;

  Definition3(this.definition);

  @override
  T create(DefinitionParameters parameters, Scope scope) {
    return definition(
        scope, parameters.param1, parameters.param2, parameters.param3);
  }
}
