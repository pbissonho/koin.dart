import 'package:koin/koin.dart';
import 'package:koin/src/lazy.dart';
import 'package:test/test.dart';

import '../components.dart';

void main() {
  test('shoud return the initialized value', () {
    var a1Instance = ComponentA();

    var a1 = lazy(() => a1Instance);

    expect(a1(), a1Instance);
    expect(a1.value, a1Instance);
    expect(true, a1.isInitialized);
  });

  test('shoud not be initializad', () {
    var a1Instance = ComponentA();

    var a1 = lazy(() => a1Instance);

    expect(false, a1.isInitialized);
  });

  test('can lazy resolve a single', () {
    var app = koinApplication((app) {
      app.module(Module()..single((s) => ComponentA()));
    });

    var a1 = app.koin.inject<ComponentA>();
    var a2 = app.koin.inject<ComponentA>();

    expect(a1, a2);
  });
}
