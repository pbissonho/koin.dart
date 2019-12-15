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
}
