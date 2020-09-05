import '../scope/scope.dart';
import 'parameter.dart';

typedef ProviderCreate<T> = T Function(Scope scope);

typedef ProviderCreateParam<T, A> = T Function(Scope scope, A param);

abstract class ProviderCreateBase<T> {
  T create(Parameter parameter, Scope scope);
}

class ProviderCreateDefinition<T> implements ProviderCreateBase<T> {
  final ProviderCreate<T> _create;

  ProviderCreateDefinition(this._create);

  @override
  T create(Parameter parameter, Scope scope) {
    return _create(scope);
  }
}

class ProviderCreateParamDefinition<T, A> implements ProviderCreateBase<T> {
  final ProviderCreateParam<T, A> _create;

  ProviderCreateParamDefinition(this._create);

  @override
  T create(Parameter parameter, Scope scope) {
    return _create(scope, parameter.get());
  }
}
