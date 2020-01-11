import 'package:koin/koin.dart';
import 'package:koin_test/koin_test.dart';
import 'package:koin_test/src/check/check_modules.dart';
import 'package:koin_test/src/mock/declare_mock.dart';
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
  ..single<Service>(((s, p) => Service()))
  ..factory<ServiceC>(((s, p) => ServiceC(p.component1(), p.component2())));
var invalidModule = Module()..single<ServiceB>(((s, p) => ServiceB(s.get())));

void main() {
  koinTest();

  testModule('MyModule', customModule,
      checkParameters: checkParametersOf({
        ServiceC: parametersOf(['Name', 'LastName'])
      }));

  testModule('valid module', customModule,
      checkParameters: checkParametersOf({
        ServiceC: parametersOf(['Name', 'LastName']),
      }));

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

    var serviceMock = ServiceMock();
    when(serviceMock.getName()).thenReturn('MockName');

    declareMock<Service>(serviceMock);

    var service = get<Service>();

    expect(service, isNotNull);
    expect(service, isA<ServiceMock>());
    expect(service.getName(), 'MockName');
  });

  test(('shoud return a Fake instance'), () {
    declare(customModule);

    var serviceMock = ServiceFake();

    declareMock<Service>(serviceMock);

    var service = get<Service>();

    expect(service, isNotNull);
    expect(service, isA<ServiceFake>());
    expect(service.getName(), 'FakeName');
  });
}
