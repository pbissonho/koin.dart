import 'package:koin/koin.dart';
import 'package:koin/src/context/context_functions.dart';
import 'package:koin/src/context/context_handler.dart';
import 'package:test/test.dart';

import '../components.dart';

void main() {
  test('can resolve a single', () {
    var moduleX = module()
      ..singleWithParam<MySingle, int>((s, id) => MySingle(id));

    startKoin((app) {
      app.module(moduleX);
    });

    var koin = KoinContextHandler.get();

    var a1 = koin.getWithParam<MySingle, int>(42);

    expect(42, a1.id);

    stopKoin();

    startKoin((app) {
      app.module(moduleX);
    });

    var a3 = KoinContextHandler.get().getWithParam<MySingle, int>(24);

    expect(24, a3.id);

    stopKoin();
  });
}
