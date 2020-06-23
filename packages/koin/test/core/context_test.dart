import 'package:koin/koin.dart';
import 'package:koin/src/core/error/exceptions.dart';

//import '../../lib/src/core/error/exceptions.dart';

import 'package:test/test.dart';

void main() {
  test('shoud not get the context', () {
    expect(() {
      var koin = KoinContextHandler.get();
    }, throwsA((error) => error is IllegalStateException));
  });

  test('shoud be null', () {
    var koin = KoinContextHandler.getOrNull();
    expect(koin, isNull);
    startKoin((app) {});
    var koinB = KoinContextHandler.getOrNull();
    expect(koinB, isNotNull);
    stopKoin();
  });

  test('shoud not start - KoinContextHandler', () {
    startKoin((app) {});
    expect(() {
      KoinContextHandler.getContext().setup(KoinApplication());
    }, throwsA((error) => error is KoinAppAlreadyStartedException));

    stopKoin();
  });

  test('shoud not start', () {
    startKoin((app) {});
    expect(() {
      startKoin((app) {});
    }, throwsA((error) => error is IllegalStateException));

    stopKoin();
  });
}
