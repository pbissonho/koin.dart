import 'package:koin/src/core/global_context.dart';
import 'package:koin/src/core/module.dart';
import 'package:test/test.dart';

abstract class IService {
  void dispose();
}

class ServiceImpl implements IService {
  @override
  void dispose() {
    print("ServiceImpl closed");
  }
}

abstract class IAuthService {
  void dispose();
}

class AuthServiceImpl implements IAuthService {
  @override
  void dispose() {
    print("AuthServiceImpl closed");
  }
}

var appModule = Module()
  ..single<IService>((s, p) => ServiceImpl())
      .bind(ServiceImpl)
      .onClose((service) {});

var authModule = Module()
  ..single<IAuthService>((s, p) => AuthServiceImpl())
      .bind(AuthServiceImpl)
      .onClose((service) => service.dispose());

void main() {
  test("start koin", () {
    var koinApp = startKoin((app) {
      app.printLogger();
      app.modules([appModule, authModule]);
    });

    var service = koinApp.koin.get<IService>(null, null);
    var serviceBind = koinApp.koin.get<ServiceImpl>(null, null);

    expect(service, isNotNull);
    expect(serviceBind, isNotNull);
  });
}
