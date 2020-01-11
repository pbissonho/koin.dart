import 'package:koin/koin.dart';

import 'home.dart';

var namedCounterQ = named("CounterX");

var appModule = Module()
  ..single((s, p) => Counter())
  ..single((s, p) => Counter(), qualifier: namedCounterQ);
