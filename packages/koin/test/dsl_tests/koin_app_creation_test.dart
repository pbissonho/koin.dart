import 'package:koin/internals.dart';
import 'package:koin/koin.dart';
import 'package:koin/src/internal/exceptions.dart';
import 'package:test/test.dart';

import '../extensions/expect.dart';

void main() {
  test('make a Koin application', () {
    koinApplication((app) {});

    expectHasNoStandaloneInstance();
  });

  test('start a Koin application', () {
    var app = startKoin((app) {});

    expect(KoinContextHandler.get(), app.koin);

    stopKoin();

    expectHasNoStandaloneInstance();
  });

  test("can't restart a Koin application", () {
    var app = startKoin((app) {});

    expect(KoinContextHandler.get(), app.koin);

    expect(() {
      startKoin((app) {});
    }, throwsA(isA<IllegalStateException>()));

    stopKoin();
  });

  test('allow declare a logger', () {
    startKoin((app) {
      app.logger(Logger.print(Level.error));
    });

    expect(KoinContextHandler.get().logger.level, Level.error);
    KoinContextHandler.get().logger.debug('debug');
    KoinContextHandler.get().logger.info('info');
    KoinContextHandler.get().logger.error('error');

    stopKoin();
  });

  test('allow declare a print logger level', () {
    startKoin((app) {
      app.printLogger(level: Level.error);
    });

    expect(KoinContextHandler.get().logger.level, Level.error);
    KoinContextHandler.get().logger.debug('debug');
    KoinContextHandler.get().logger.info('info');
    KoinContextHandler.get().logger.error('error');

    stopKoin();
  });
}
