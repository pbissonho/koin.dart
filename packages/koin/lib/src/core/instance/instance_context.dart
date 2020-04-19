import '../../koin_dart.dart';
import '../definition_parameters.dart';
import '../scope.dart';

///
/// Instance resolution Context
/// Help support DefinitionContext & DefinitionParameters when resolving definition function
///
class InstanceContext {
  final Koin koin;
  final Scope scope;
  DefinitionParameters _parameters;
  DefinitionParameters get parameters => _parameters;

  InstanceContext({this.koin, this.scope, DefinitionParameters parameters}) {
    if (parameters == null) {
      _parameters = emptyParametersHolder();
    }
    _parameters = parameters;
  }
}
