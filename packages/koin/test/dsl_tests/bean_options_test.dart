import 'package:koin/koin.dart';
import 'package:test/test.dart';

import '../components.dart';
import '../extensions/koin_application_ext.dart';

void main() {
  test('definition created at start', () {
    var app = koinApplication((app) {
      app.module(Module()
        ..single((s) => ComponentA(), createdAtStart: true)
        ..single((s) => ComponentB(s.get())));
    });

    var defA = app.getBeanDefinition(ComponentA);
    expect(true, defA.options.isCreatedAtStart);

    var defB = app.getBeanDefinition(ComponentB);
    expect(false, defB.options.isCreatedAtStart);
  });

  test('definition override', () {
    var app = koinApplication((app) {
      app.module(Module()
        ..single((s) => ComponentA())
        ..single((s) => ComponentB(s.get()), override: true));
    });

    var defA = app.getBeanDefinition(ComponentA);
    expect(false, defA.options.override);

    var defB = app.getBeanDefinition(ComponentB);
    expect(true, defB.options.override);
  });
}
