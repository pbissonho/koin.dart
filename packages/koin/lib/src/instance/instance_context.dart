import '../definition/parameter.dart';
import '../scope/scope.dart';
import '../koin_dart.dart';

///
/// Instance resolution Context
/// Help support DefinitionContext & DefinitionParameters when resolving
/// definition function
///
class InstanceContext {
  final Koin koin;
  final Scope scope;
  Parameter parameter;

  InstanceContext({this.koin, this.scope, this.parameter}) {
    parameter ??= emptyParameter();
  }
}
