import '../scope/scope.dart';
import '../koin_dart.dart';
import '../definition_parameters.dart';

///
/// Instance resolution Context
/// Help support DefinitionContext & DefinitionParameters when resolving
/// definition function
///
class InstanceContext {
  final Koin koin;
  final Scope scope;
  DefinitionParameters parameters;

  InstanceContext({this.koin, this.scope, this.parameters}) {
    parameters ??= emptyParametersHolder();
  }
}
