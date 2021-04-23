import 'observer.dart';
import '../../instance_factory.dart';

class EmptyLoggerObserver implements LoggerObserver {
  EmptyLoggerObserver();

  @override
  void onDispose(InstanceFactory instanceFactory) {}
  @override
  void onResolve(String type, String duration) {}
  @override
  void onCreate(InstanceFactory instanceFactory) {}
}
