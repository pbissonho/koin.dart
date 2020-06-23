import 'package:koin/koin.dart';
import 'package:test/test.dart';

import '../components.dart';

class MyComponent extends KoinComponent {
  MyComponent() {
    get<ComponentA>();
  }
}

void main() {
  test('1st test', () {
    startKoin((app) {
      app.module(module()..single((s) => ComponentA()));
    });
    MyComponent();
    stopKoin();
  });

  test('1st test', () {
    startKoin((app) {
      app.module(module()..single((s) => ComponentA()));
    });
    MyComponent();
    stopKoin();
  });
}
