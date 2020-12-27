import '../../instance_factory.dart';
import '../scope/scope.dart';

import '../../koin.dart';

abstract class ScopeObserver {
  void onCreate(Scope scope);
  void onClose(Scope scope);
}

abstract class InstanceObserver {
  void onCreate(InstanceFactory instanceFactory);
  void onDispose(InstanceFactory instanceFactory);
  void onResolve(String type, String duration);
}

class LoggerObserver implements InstanceObserver {
  final Koin _koin;

  LoggerObserver(this._koin);

  @override
  void onDispose(InstanceFactory instanceFactory) {
    _koin.logger.isAtdebug(
        '''| dispose instance for ${instanceFactory.beanDefinition}''',
        Level.debug);
  }

  @override
  void onResolve(String type, String duration) {
    _koin.logger.debug("+- get '${type.toString()} in $duration ms'");
  }

  @override
  void onCreate(InstanceFactory instanceFactory) {
    _koin.logger.isAtdebug(
        '''| create instance for ${instanceFactory.beanDefinition}''',
        Level.debug);
  }
}
