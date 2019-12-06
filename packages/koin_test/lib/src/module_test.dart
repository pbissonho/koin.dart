import 'package:koin/koin.dart';
import 'package:koin_test/koin_test.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

@isTest
void moduleTest(
  String description,
  Module module,
  CheckParameters checkParameters, {
  String testOn,
  Timeout timeout,
  dynamic skip,
  dynamic tags,
  Map<String, dynamic> onPlatform,
  int retry,
}) {
  test(description, () {
    checkModules([module], checkParameters);
  },
      testOn: testOn,
      tags: tags,
      timeout: timeout,
      skip: skip,
      retry: retry,
      onPlatform: onPlatform);
}

@isTest
void modulesTest(
    String description, List<Module> modules, CheckParameters checkParameters,
    {String testOn,
    Timeout timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic> onPlatform,
    int retry}) {
  test(description, () {
    if (checkParameters == null) {
      checkParameters = CheckParameters();
    }
    checkModules(modules, checkParameters);
  },
      testOn: testOn,
      tags: tags,
      timeout: timeout,
      skip: skip,
      retry: retry,
      onPlatform: onPlatform);
}
