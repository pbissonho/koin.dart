import 'package:koin/koin.dart';
import 'package:koin_and_bloc/counter_bloc.dart';

var appModule = Module()..single<CounterBloc>((s, p) => CounterBloc());
