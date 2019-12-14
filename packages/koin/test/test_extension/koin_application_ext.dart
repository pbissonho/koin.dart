import 'package:koin/koin.dart';
import 'package:koin/src/koin_application.dart';
import 'package:test/test.dart';

extension KoinApplicationExtension on KoinApplication {
  expectDefinitionsCount(int count) {
    expect(count, this.koin.rootScope.beanRegistry.size());
  }

  BeanDefinition getDefinition(Type type) {
    return this.koin.rootScope.beanRegistry.getDefinition(type);
  }
}
