import 'package:koin/koin.dart';

import 'src/counter.dart';

var homeModule = module()
  ..single((s, p) => Counter(0))
  ..factory((s, p) => Counter(p.param1), qualifier: named("Fac"));
