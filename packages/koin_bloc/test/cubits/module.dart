import 'package:koin/koin.dart';
import 'package:koin_bloc/koin_bloc.dart';

import '../bloc/counter_bloc.dart';
import 'counter_cubit.dart';

class ScopeKey {}

final cubitModule = Module()
  ..bloc((s) => CounterCubit())
  ..scopeOneBloc((scope) => CounterCubit())
  ..scope<ScopeKey>((scope) {
    scope.scopedBloc<CounterCubit>((scope) => CounterCubit());
  });

final blocModule = Module()
  ..bloc((s) => CounterBloc())
  ..scopeOneBloc((scope) => CounterBloc())
  ..scope<ScopeKey>((scope) {
    scope.scopedBloc<CounterBloc>((scope) => CounterBloc());
  });
