import 'package:koin/koin.dart';
import 'package:koin_flutter/koin_disposable.dart';
import 'package:koin_flutter/koin_bloc.dart';
import 'pages.dart';

final testModule1 = Module()
  ..bloc((s) => Bloc())
  ..scope<ScopeWidget>((scope) {
    scope.scopedDisposable<Bloc>((s) => Bloc());
  });

final testModule2 = Module()
  ..disposable((s) => Bloc())
  ..scopeOneDisposable<Bloc, UseScopeWidget>((scope) => Bloc());

final testModule3 = Module()
  ..disposable((s) => Bloc())
  ..scope<UseScopeExtensionWidget>((scope) {
    scope.scopedBloc<Bloc>((s) => Bloc());
  });
