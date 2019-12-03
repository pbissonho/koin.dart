import 'package:koin/koin.dart';
import 'package:koin_test/koin_test.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

@isTest
void moduleTest(
    String description, Module module, CheckParameters checkParameters) {
  test(description, () {
    KoinApplication app = KoinApplication.create();
    app.module(module);
    app.createEagerInstances();
    appCheckModules(checkParameters, app);
  });
}
