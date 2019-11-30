import 'package:koin/koin.dart';

import 'blocs/counter_bloc.dart';

var appModule = Module()..single<CounterBloc>((s, p) => CounterBloc());
