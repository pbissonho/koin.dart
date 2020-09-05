import 'package:koin/koin.dart';
import 'pages.dart';

final module1 = Module()
  ..single((s) => Component(20)).bind<ComponentInterface>()
  ..factoryWithParam<Component, int>((s, id) => Component(id),
      qualifier: named("Fac"))
  ..scope<HomePage>((s) {
    s.scoped((s) => Component(50));
  });

final moduleWithParams = Module()
  ..factoryWithParam<Component, int>((s, value) => Component(value))
      .bind<ComponentInterface>()
  ..factoryWithParam<ComponentB, int>((s, value) => ComponentB(value))
      .bind<ComponentBInterface>()
  ..factoryWithParam<Component, int>((s, id) => Component(id),
      qualifier: named("Fac"))
  ..scope<HomePageWithParams>((s) {
    s.scopedWithParam<Component, int>((s, value) => Component(value));
  });
