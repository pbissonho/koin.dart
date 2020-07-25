import 'package:koin/koin.dart';
import 'package:koin_bloc/koin_bloc.dart';

import 'counter_cubit.dart';

class ScopeKey {}

var cubitModule = Module()
  ..cubit((s) => CounterCubit())
  ..scopeOneCubit((scope) => CounterCubit())
  ..scope<ScopeKey>((scope) {
    scope.scopedCubit<CounterCubit>((scope) => CounterCubit());
  });
