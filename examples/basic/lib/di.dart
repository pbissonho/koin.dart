import 'package:koin/koin.dart';

import 'home.dart';

var namedCounterQ = named("CounterX");

var appModule = Module()
  ..single((s) => Counter())
  ..single((s) => Counter(), qualifier: namedCounterQ);
