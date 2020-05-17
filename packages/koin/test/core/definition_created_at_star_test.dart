import 'package:koin/koin.dart';
import 'package:koin/src/core/context/context_functions.dart';
import 'package:test/test.dart';

import '../components.dart';
import '../extensions/koin_application_ext.dart';

void main() {
  test('is declared as created at start', () {
    var app = koinApplication((app) {
      app.module(module()
        ..single<ComponentA>((s, p) => ComponentA(), createdAtStart: true));
    });

    var defA = app.getBeanDefinition(ComponentA);
    expect(true, defA.options.isCreatedAtStart);

    var instanceFactory = app.getInstanceFactory(ComponentA);
    expect(false, instanceFactory.isCreated());
  });

  test('is created at start', () {
    var app = startKoin((app) {
      app.module((module()
        ..single<ComponentA>((s, p) => ComponentA(), createdAtStart: true)));
    });

    var defA = app.getBeanDefinition(ComponentA);
    expect(true, defA.options.isCreatedAtStart);
    var instanceFactory = app.getInstanceFactory(ComponentA);
    expect(true, instanceFactory.isCreated());
    
    stopKoin();
  });


  test('factory is not created at start', () {
    var app = koinApplication((app) {
      app.module(module()
        ..single<ComponentA>((s, p) => ComponentA()));
    });

    var defA = app.getBeanDefinition(ComponentA);
    expect(false, defA.options.isCreatedAtStart);

    var instanceFactory = app.getInstanceFactory(ComponentA);
    expect(false, instanceFactory.isCreated());

    app.close();
  });

}
