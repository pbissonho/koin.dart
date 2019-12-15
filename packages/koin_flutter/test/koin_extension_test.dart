import 'package:koin/koin.dart';
import 'package:koin_flutter/koin_bloc.dart';

class Bloc implements Disposable {
  @override
  void dispose() {}
}

class ScopedBloc implements Disposable {
  @override
  void dispose() {}
}

var blocModule = Module()
  ..bloc((s, p) => Bloc())
  ..scope(named("BlocScope"), (scope) {
    scope.scopedBloc<ScopedBloc>((s,p) => ScopedBloc());
  });
