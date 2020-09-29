import 'package:koin/koin.dart';
import 'package:koin_test/koin_test.dart';
import 'package:test/test.dart';

import 'cubits/counter_cubit.dart';
import 'cubits/module.dart';

void main() {
  Koin koin;
  group('bloc extension', () {
    setUp(() {
      koin = startKoin((app) {
        app.module(cubitModule);
      }).koin;
    });

    group('shoud resolve', () {
      koinTearDown();

      test('a single bloc', () {
        var bloc = koin.get<CounterCubit>();
        expect(bloc, isNotNull);
      });

      test('shoud resolve a single bloc', () {
        var bloc = koin.get<CounterCubit>();
        expect(bloc, isNotNull);
      });

      test('shoud resolve a scoped bloc', () {
        var scope = koin.createScope<ScopeKey>('myScope');
        var bloc = scope.get<CounterCubit>();
        expect(bloc, isNotNull);
      });

      test('shoud resolve a scoped bloc - scopeOne', () {
        var scope = koin.createScope<ScopeKey>('myScope');
        var bloc = scope.get<CounterCubit>();
        expect(bloc, isNotNull);
      });
    });

    group('shoud close', () {
      test('the single bloc definition when the stop koin', () async {
        var bloc = koin.get<CounterCubit>();
        await expectLater(bloc, emits(emitsDone));
        stopKoin();
      });

      test('the bloc instance is disposed when the scope is closed koin',
          () async {
        var scope = koin.createScope<ScopeKey>('myScope');
        var bloc = scope.get<CounterCubit>();
        scope.close();

        await expectLater(bloc, emits(emitsDone));
      });
    });
  });
}
