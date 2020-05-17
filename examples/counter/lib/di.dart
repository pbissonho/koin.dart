import 'package:koin/koin.dart';

import 'src/counter.dart';

var homeModule = module()
  ..single((s) => Counter(0))
  ..factory1<Counter, int>((s, value) => Counter(value),
      qualifier: named("Fac"));
