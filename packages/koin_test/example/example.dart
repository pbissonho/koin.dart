import 'package:flutter_test/flutter_test.dart';
import 'package:koin/koin.dart';
import 'package:koin_test/koin_test.dart';
import 'package:mockito/mockito.dart';

// Just a few services to exemplify.
class ServiceA {
  String getName() => 'Name';
}

class ServiceB {
  final ServiceA service;

  ServiceB(this.service);
  String getName() => 'Name';
}

class ServiceParam {
  final String firstName;
  final String lastName;

  ServiceParam(this.firstName, this.lastName);
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
  ..single<ServiceA>(((s) => ServiceA()))
  ..factoryWithParam<ServiceC, ServiceParam>(
      ((s, param) => ServiceC(param.firstName, param.lastName)));

// Since ServiceC has not been defined, koin will throw an exception when trying
// to instantiate ServicoB.
var invalidModule = Module()..single<ServiceB>(((s) => ServiceB(s.get())));

void main() {
  // Configures the testing environment to automatically start and close Koin for each test.
  koinTest();

  testModule('shoud be a valid module', customModule,
      checkParameters: checkParametersOf({
        ServiceC: ServiceParam('Name', 'LastName'),
      }));

  test('shoud be a invalid module', () {
    expect(() {
      checkModules(Level.error, CheckParameters(), (app) {
        app.module(invalidModule);
      });
    }, throwsException);
  });

  test('shoud return mock instance', () {
    declareModule((module) {
      module
        ..single<ServiceA>(((s) => ServiceA()))
        ..factoryWithParam<ServiceC, ServiceParam>(
            ((s, param) => ServiceC(param.firstName, param.lastName)));
    });

    var serviceMock = ServiceAMock();
    when(serviceMock.getName()).thenReturn('MockName');

    // Declare a MockInstance for te ServiceA
    declare<ServiceA>(serviceMock);

    var service = get<ServiceA>();

    expect(service, isNotNull);
    expect(service, isA<ServiceAMock>());
    expect(service.getName(), 'MockName');
  });

  test(('shoud return a Fake instance'), () {
    declareModule((module) {
      module
        ..single<ServiceA>(((s) => ServiceA()))
        ..factoryWithParam<ServiceC, ServiceParam>(
            ((s, param) => ServiceC(param.firstName, param.lastName)));
    });

    var serviceMock = ServiceFake();

    declare<ServiceA>(serviceMock);

    var service = get<ServiceA>();

    expect(service, isNotNull);
    expect(service, isA<ServiceFake>());
    expect(service.getName(), 'FakeName');
  });
}
