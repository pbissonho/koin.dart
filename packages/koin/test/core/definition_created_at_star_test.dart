import 'package:koin/koin.dart';
import 'package:koin/src/context/context_functions.dart';
import 'package:koin/src/instance/single_instance_factory.dart';
import 'package:test/test.dart';

import '../components.dart';
import '../extensions/koin_application_ext.dart';

void main() {
  test('is declared as created at start', () {
    var app = koinApplication((app) {
      app.module(module()
        ..single<ComponentA>((s) => ComponentA(), createdAtStart: true));
    });

    var defA = app.getBeanDefinition(ComponentA);
    expect(true, defA.options.isCreatedAtStart);

    var instanceFactory = app.getInstanceFactory(ComponentA);
    expect(false, (instanceFactory as SingleInstanceFactory).created);
  });

  test('is created at start', () {
    var app = startKoin((app) {
      app.module((module()
        ..single<ComponentA>((s) => ComponentA(), createdAtStart: true)));
    });

    var defA = app.getBeanDefinition(ComponentA);
    expect(true, defA.options.isCreatedAtStart);
    var instanceFactory = app.getInstanceFactory(ComponentA);
    expect(true, (instanceFactory as SingleInstanceFactory).created);

    stopKoin();
  });

  test('factory is not created at start', () {
    var app = koinApplication((app) {
      app.module(module()..single<ComponentA>((s) => ComponentA()));
    });

    var defA = app.getBeanDefinition(ComponentA);
    expect(false, defA.options.isCreatedAtStart);

    var instanceFactory = app.getInstanceFactory(ComponentA);
    expect(false, (instanceFactory as SingleInstanceFactory).created);

    app.close();
  });
}
