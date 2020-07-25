import 'package:koin/koin.dart';
import 'package:koin_flutter/koin_disposable.dart';
import 'pages.dart';

var testModule1 = Module()
  ..disposable((s) => Bloc())
  ..scope<ScopeWidget>((scope) {
    scope.scopedDisposable<Bloc>((s) => Bloc());
  });

var testModule2 = Module()
  ..disposable((s) => Bloc())
  ..scope<UseScopeWidget>((scope) {
    scope.scopedDisposable<Bloc>((s) => Bloc());
  });

var testModule3 = Module()
  ..disposable((s) => Bloc())
  ..scope<UseScopeExtensionWidget>((scope) {
    scope.scopedDisposable<Bloc>((s) => Bloc());
  });