import 'package:koin/koin.dart';
import 'package:koin_test/koin_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

// Just a few services to exemplify.
class ServiceA {
  String getName() => 'Name';
}

class ServiceB {
  final ServiceA service;

  ServiceB(this.service);
  String getName() => 'Name';
}

class ServiceC {
  final String firstName;
  final String lastName;

  ServiceC(this.firstName, this.lastName);

  String getName() => '$firstName $lastName';
}

// Create a Mock for a particular service as usual.
class ServiceAMock extends Mock implements ServiceA {}

// Create a Fake for a particular service as usual.
class ServiceFake extends Fake implements ServiceA {
  String getName() {
    return 'FakeName';
  }
}

var customModule = Module()
  ..single<ServiceA>(((s, p) => ServiceA()))
  ..factory<ServiceC>(((s, p) => ServiceC(p.component1(), p.component2())));

// Since ServiceC has not been defined, koin will throw an exception when trying
// to instantiate ServicoB.
var invalidModule = Module()..single<ServiceB>(((s, p) => ServiceB(s.get())));

void main() {
  // Configures the testing environment to automatically start and close Koin for each test.
  koinTest();

  test(('shoud be a valid module '), () {
    checkModules(
        [customModule],
        checkParametersOf({
          ServiceC: parametersOf(['Name', 'LastName']),
        }));
  });

  test(('shoud be a invalid module '), () {
    expect(() {
      checkModules([customModule], CheckParameters());
    }, throwsException);
  });

  test('shoud return mock instance', () {
    declare(customModule);

    var serviceMock = ServiceAMock();
    when(serviceMock.getName()).thenReturn('MockName');

    // Declare a MockInstance for te ServiceA
    declareMock<ServiceA>(serviceMock);

    var service = get<ServiceA>();

    expect(service, isNotNull);
    expect(service, isA<ServiceAMock>());
    expect(service.getName(), 'MockName');
  });

  test(('shoud return a Fake instance'), () {
    declare(customModule);

    var serviceMock = ServiceFake();

    declareMock<ServiceA>(serviceMock);

    var service = get<ServiceA>();

    expect(service, isNotNull);
    expect(service, isA<ServiceFake>());
    expect(service.getName(), 'FakeName');
  });
}
