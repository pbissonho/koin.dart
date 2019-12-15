import 'package:koin/koin.dart';
import 'package:koin/src/core/instance/definition_instance.dart';
import 'package:koin/src/core/lazy/lazy.dart';
import 'package:test/test.dart';

class Service {
  const Service();
}

void main() {
  test("shoud return the initialized value", () {
    var serviceInstance = Service();

    Lazy<Service> service = lazy(() => serviceInstance);

    expect(service(), serviceInstance);
    expect(service.value, serviceInstance);
    expect(true, service.isInitialized);
  });

  test("shoud not be initializad", () {
    var serviceInstance = Service();

    Lazy<Service> service = lazy(() => serviceInstance);

    expect(false, service.isInitialized);
  });

  test("shoud return an uninitialized Lazy instance", () {
    var serviceInstance = Service();

    var koin = KoinApplication()
        .printLogger()
        .module(module()..single((s,p) => serviceInstance))
        .koin;

    Lazy<Service> service = koin.inject<Service>();

    var definition = koin.rootScope.beanRegistry.findDefinition(null, Service);

    expect(false, definition.intance.isCreated(InstanceContext()));
    expect(false, service.isInitialized);
  });

  test("shoud return the inject single value", () {
    var serviceInstance = Service();

    var koin = KoinApplication()
        .printLogger()
        .module(module()..single((s,p) => serviceInstance))
        .koin;

    Lazy<Service> service = koin.inject<Service>();

    expect(serviceInstance, service());
    expect(serviceInstance, service.value);
    expect(true, service.isInitialized);
  });
}
