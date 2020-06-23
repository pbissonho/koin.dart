import 'package:koin/koin.dart';
import 'package:test/test.dart';

import '../components.dart';

class MyComponent extends KoinComponent {
  MyComponent() {
    get<ComponentA>();
  }
}

void main() {
  setUp(() {
    startKoin((app) {
      app.module(module()..single((s) => ComponentA()));
    });
  });

  tearDown(stopKoin);
  test('1st test', () {
    MyComponent();
  });

  test('1st test', () {
    MyComponent();
  });
}
