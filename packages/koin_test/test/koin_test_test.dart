import 'package:koin/koin.dart';
import 'package:koin_test/koin_test.dart';
import 'package:mockito/mockito.dart';

import 'package:test/test.dart';

class Service {
  String getName() {
    return 'Name';
  }
}

class ServiceB {
  final Service service;

  ServiceB(this.service);
  String getName() {
    return 'Name';
  }
}

class ServiceParam {
  final String name;
  final String lastName;

  ServiceParam(this.name, this.lastName);
}

class ServiceC {
  final String name;
  final String lastName;

  ServiceC(this.name, this.lastName);

  String getName() {
    return name;
  }
}

class ServiceMock extends Mock implements Service {}

class ServiceFake extends Fake implements Service {
  @override
  String getName() {
    return 'FakeName';
  }
}

var customModule = Module()
  ..single<Service>(((s) => Service()))
  ..factoryWithParam<ServiceC, ServiceParam>(
      ((s, param) => ServiceC(param.name, param.lastName)));

var moduleWithScope = Module()
  ..scope((s) {
    s.scoped<Service>(((s) => Service()));
    s.factoryWithParam<ServiceC, ServiceParam>(
        ((s, param) => ServiceC(param.name, param.lastName)));
  });

var invalidModule = Module()..single<ServiceB>(((s) => ServiceB(s.get())));

void main() {
  koinTest();

  var appDeclaration = koinApplication((app) {
    app.module(customModule);
  });

  var appDeclarationInvalid = koinApplication((app) {
    app.module(invalidModule);
  });

  var checkParameters = CheckParameters()
    ..create<ServiceC, ServiceParam>(ServiceParam('Name', 'LastName'));

  testKoinDeclaration('SimpleTest', (app) {
    app.module(customModule);
  }, checkParameters: checkParameters);

  testModule('MyModule', customModule,
      checkParameters: checkParametersOf({
        ServiceC: ServiceParam('Name', 'LastName'),
      }));

  testModule('valid module', customModule,
      checkParameters: checkParametersOf({
        ServiceC: ServiceParam('Name', 'LastName'),
      }));

  testModule('valid module with scope', moduleWithScope,
      checkParameters: checkParametersOf({
        ServiceC: ServiceParam('Name', 'LastName'),
      }));

  test(('shoud be a valid module '), () {
    appDeclaration.checkModules(checkParametersOf({
      ServiceC: ServiceParam('Name', 'LastName'),
    }));
  });

  test(('shoud be a invalid module '), () {
    expect(() {
      appDeclarationInvalid.checkModules(CheckParameters());
    }, throwsException);
  });

  test('shoud return mock instance', () {
    declareModule((module) {
      module
        ..single<Service>(((s) => Service()))
        ..factoryWithParam<ServiceC, ServiceParam>(
            ((s, param) => ServiceC(param.name, param.lastName)));
    });

    var serviceMock = ServiceMock();
    when(serviceMock.getName()).thenReturn('MockName');

    declare<Service>(serviceMock);

    var service = get<Service>();

    expect(service, isNotNull);
    expect(service, isA<ServiceMock>());
    expect(service.getName(), 'MockName');
  });

  test(('shoud return a Fake instance'), () {
    declareModule((module) {
      module
        ..single<Service>(((s) => Service()))
        ..factoryWithParam<ServiceC, ServiceParam>(
            ((s, param) => ServiceC(param.name, param.lastName)));
    });

    var serviceMock = ServiceFake();

    declare<Service>(serviceMock);

    var service = get<Service>();

    expect(service, isNotNull);
    expect(service, isA<ServiceFake>());
    expect(service.getName(), 'FakeName');
  });
}
