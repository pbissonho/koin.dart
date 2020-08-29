import 'package:koin/koin.dart';
import 'pages.dart';

var module1 = Module()
  ..single((s) => Component(20)).bind<ComponentInterface>()
  ..factoryWithParam<Component, int>((s, id) => Component(id),
      qualifier: named("Fac"))
  ..scope<HomePage>((s) {
    s.scoped((s) => Component(50));
  });

var module2 = Module()
  ..single((s) => Component(20)).bind<ComponentInterface>()
  ..factoryWithParam<Component, int>((s, id) => Component(id),
      qualifier: named("Fac"))
  ..scope<HomePageStateless>((s) {
    s.scoped((s) => Component(50));
  });

var module3 = Module()
  ..single((s) => Component(20)).bind<ComponentInterface>()
  ..factoryWithParam<Component, int>((s, id) => Component(id),
      qualifier: named("Fac"))
  ..scope<HomePage3>((s) {
    s.scoped((s) => Component(50));
  });

var moduleWithParams = Module()
  ..factoryWithParam<Component, int>((s, value) => Component(value))
      .bind<ComponentInterface>()
  ..factoryWithParam<ComponentB, int>((s, value) => ComponentB(value))
      .bind<ComponentBInterface>()
  ..factoryWithParam<Component, int>((s, id) => Component(id),
      qualifier: named("Fac"))
  ..scope<HomePageWithParams>((s) {
    s.scoped1<Component, int>((s, value) => Component(value));
  });
