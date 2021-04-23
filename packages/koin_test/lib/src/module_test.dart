import 'package:koin/koin.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

import 'check/check_module_dsl.dart';
import 'check/check_modules.dart';

@isTest
void testKoinDeclaration(
  String description,
  Function(KoinApplication app) appDeclaration, {
  Level level = Level.none,
  CheckParameters? checkParameters,
  String? testOn,
  Timeout? timeout,
  dynamic? skip,
  dynamic? tags,
  Map<String, dynamic>? onPlatform,
  int? retry,
}) {
  test(description, () {
    checkModules(level, checkParameters, appDeclaration);
  },
      testOn: testOn,
      tags: tags,
      timeout: timeout,
      skip: skip,
      retry: retry,
      onPlatform: onPlatform);
}

@isTest
void testModules(String description, List<Module> modules,
    {Level level = Level.none,
    CheckParameters? checkParameters,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry}) {
  test(description, () {
    checkModules(level, checkParameters, (app) {
      app.modules(modules);
    });
  },
      testOn: testOn,
      tags: tags,
      timeout: timeout,
      skip: skip,
      retry: retry,
      onPlatform: onPlatform);
}

@isTest
void testModule(String description, Module module,
    {Level level = Level.none,
    CheckParameters? checkParameters,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry}) {
  test(description, () {
    checkModules(level, checkParameters, (app) {
      app.module(module);
    });
  },
      testOn: testOn,
      tags: tags,
      timeout: timeout,
      skip: skip,
      retry: retry,
      onPlatform: onPlatform);
}
