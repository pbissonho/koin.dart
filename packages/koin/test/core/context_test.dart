import 'package:koin/koin.dart';
import 'package:koin/src/core/error/exceptions.dart';

//import '../../lib/src/core/error/exceptions.dart';

import 'package:test/test.dart';

void main() {
  group('with context', () {
    test('shoud not get the context', () {
      expect(KoinContextHandler.get,
          throwsA((error) => error is IllegalStateException));
    });

    test('shoud not get the koin from context', () {
      KoinContextHandler.register(GlobalContext());
      expect(KoinContextHandler.get,
          throwsA((error) => error is IllegalStateException));

      KoinContextHandler.stop();
    });
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
