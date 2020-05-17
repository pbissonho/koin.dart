import 'package:koin/koin.dart';
import 'package:koin/src/core/context/context_functions.dart';
import 'package:koin/src/core/context/koin_context_handler.dart';
import 'package:test/test.dart';

import '../components.dart';

void main() {
  test('can resolve a single', () {
    var moduleX = module()..single((s, p) => MySingle(p.component1));

    startKoin2((app) {
      app.module(moduleX);
    });

    var koin = KoinContextHandler.get();

    var a1 = koin.getWithParams<MySingle>(parameters: parametersOf([42]));

    expect(42, a1.id);

    stopKoin();

    startKoin2((app) {
      app.module(moduleX);
    });

    var a3 = KoinContextHandler.get().getWithParams<MySingle>(parameters: parametersOf([24]));

    expect(24, a3.id);

    stopKoin();
  });
}
