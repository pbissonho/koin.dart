import 'package:koin/koin.dart';
import 'package:koin_test/koin_test.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

@isTest
void moduleTest(
  String description,
  Module module,
  CheckParameters checkParameters,
) {
  test(description, () {
    KoinApplication app = KoinApplication.create();
    app.module(module);
    app.createEagerInstances();
    appCheckModules(checkParameters, app);
  });
}

@isTest
void modulesTest(String description,
    {List<Module> modules,
    CheckParameters checkParameters,
    List<Module> dependencies}) {
  test(description, () {
    if (checkParameters == null) {
      checkParameters = CheckParameters();
    }
    KoinApplication app = KoinApplication.create();
    app.modules(modules);
    app.createEagerInstances();
    appCheckModules(checkParameters, app);
  });
}
