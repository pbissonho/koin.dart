import 'instance/instance_factory.dart';
import 'koin_dart.dart';
import 'logger.dart';

abstract class ScopeObserver {
  void onCreate();
  void onClose();
}

abstract class LoggerInstanceObserverBase {
  void onCreate(InstanceFactory instanceFactory);
  void onDispose(InstanceFactory instanceFactory);
  void onResolve(String type, String duration);
}

class LoggerInstanceObserver implements LoggerInstanceObserverBase {
  final Koin koin;

  LoggerInstanceObserver(this.koin);

  @override
  void onDispose(InstanceFactory instanceFactory) {
    koin.logger.isAtdebug(
        '''| dispose instance for ${instanceFactory.beanDefinition}''',
        Level.debug);
  }

  void onResolve(String type, String duration) {
    koin.logger.debug("+- get '${type.toString()} in $duration ms'");
  }

  @override
  void onCreate(InstanceFactory instanceFactory) {
    koin.logger.isAtdebug(
        '''| create instance for ${instanceFactory.beanDefinition}''',
        Level.debug);
  }
}
