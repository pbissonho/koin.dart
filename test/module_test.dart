import 'package:koin/src/core/global_context.dart';
import 'package:koin/src/core/koin_component.dart';
import 'package:koin/src/core/module.dart';
import 'package:koin/src/core/qualifier.dart';
import 'package:koin/src/koin_application.dart';
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
      .onClose((service) => service.dispose())
  ..scope(named("myScope")).scoped<IAuthService>();

var scopeName = named("MY_SCOPE");

var scopeName2 = named("MY_SCOPE2");

var scopeModule = Module()
  ..scope(scopeName).scoped<IService>((s, p) => ServiceImpl());

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
    var equas = service = serviceBind;

    expect(true, equas);
  });

  test("get definition from a scope", () {
    var koin = KoinApplication().module(scopeModule).koin;

    var scope = koin.createScope("myScope", scopeName);

    var service = scope.get<IService>(null, null);
    var service2 = scope.get<IService>(null, null);
    var scopeT = koin.getScope("myScope");
    var result = scopeT.get<IService>(null, null);
    var equas = service == service2 && service2 == result;

    expect(true, equas);
  });

  test("KoinComponent", () {
    var koinApp = startKoin((app) {
      app.printLogger();
      app.module(blocModule);
    });

    var myWidget = MyWidget();
    myWidget.initState();

    var widget2 = MyWidget();
    widget2.initState();
    var equas = myWidget.bloc == widget2.bloc;

    expect(myWidget.bloc, isNotNull);
    expect(widget2.bloc, isNotNull);
    expect(false, equas);

    myWidget.dispose();
    widget2.dispose();
  });
}

var blocModule = Module()
  ..scope(named<MyWidget>()).scoped<MyBloc>((s, p) => MyBloc());

class MyBloc {}

class MyWidget with KoinComponent {
  MyBloc bloc;

  void initState() {
    init();
    bloc = currentScope.inject<MyBloc>();
  }

  void dispose() {}
}
