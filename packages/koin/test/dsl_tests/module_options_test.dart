import 'package:koin/koin.dart';
import 'package:test/test.dart';

import '../components.dart';
import '../extensions/koin_application_ext.dart';

void main() {
  test('module default options', () {
    var moduleX = module();
    expect(false, moduleX.createAtStart);
    expect(false, moduleX.override);
  });
  test('module override option', () {
    var moduleX = module(override: true);
    expect(false, moduleX.createAtStart);
    expect(true, moduleX.override);
  });

  test('module options options', () {
    var moduleX = module(createdAtStart: true);
    expect(true, moduleX.createAtStart);
    expect(false, moduleX.override);
  });

  test('module options options', () {
    var moduleX = module(createdAtStart: true, override: true)
      ..single((s) => ComponentA());

    var app = koinApplication((app) {
      app.module(moduleX);
    });

    expect(true, moduleX.createAtStart);
    expect(true, moduleX.override);

    var defA = app.getBeanDefinition(ComponentA);

    if (defA == null) throw 'no definition found';
    expect(true, defA.options.isCreatedAtStart);
    expect(true, defA.options.override);
  });

  test('module definitions options non inheritance', () {
    var moduleX = module()
      ..single((s) => ComponentA(), createdAtStart: true)
      ..single((s) => ComponentB(s.get()), override: true);

    var app = koinApplication((app) {
      app.module(moduleX);
    });

    expect(false, moduleX.createAtStart);
    expect(false, moduleX.override);

    var defA = app.getBeanDefinition(ComponentA);
    if (defA == null) throw 'no definition found';
    var defB = app.getBeanDefinition(ComponentB);
    if (defB == null) throw 'no definition found';

    expect(true, defA.options.isCreatedAtStart);
    expect(false, defA.options.override);

    expect(false, defB.options.isCreatedAtStart);
    expect(true, defB.options.override);
  });
}
