import 'package:koin/koin.dart';

import 'src/counter.dart';
import 'src/home_page.dart';

var homeModule = Module()
  ..single<Counter>((s) => Counter(0))
  ..scope<MyHomePage>((s) {
    s.scoped((s) => Counter(0));
    s.factory1<Counter, int>((s, value) => Counter(value),
        qualifier: named("Fac"));
  });
