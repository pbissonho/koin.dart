import 'package:koin/koin.dart';
import 'package:koin_test/koin_test.dart';
import 'package:test/test.dart';

import 'bloc/counter_bloc.dart';
import 'cubits/counter_cubit.dart';
import 'cubits/module.dart';

void main() {
  Koin? koin;

  setUp(() {
    koin = startKoin((app) {
      app.modules([cubitModule, blocModule]);
    }).koin;
  });

  koinTearDown();

  group('cubit extension', () {
    group('shoud resolve', () {
      test('a single bloc', () {
        final bloc = koin!.get<CounterCubit>();
        expect(bloc, isNotNull);
      });

      test('shoud resolve a single bloc', () {
        final bloc = koin!.get<CounterCubit>();
        expect(bloc, isNotNull);
      });

      test('shoud resolve a scoped bloc', () {
        final scope = koin!.createScope<ScopeKey>('myScope');
        final bloc = scope.get<CounterCubit>();
        expect(bloc, isNotNull);
      });

      test('shoud resolve a scoped bloc - scopeOne', () {
        final scope = koin!.createScope<ScopeKey>('myScope');
        final bloc = scope.get<CounterCubit>();
        expect(bloc, isNotNull);
      });
    });

    group('shoud close', () {
      test('the single bloc definition when the stop koin', () async {
        final bloc = koin!.get<CounterCubit>();
        stopKoin();

        await expectLater(bloc.stream, emits(emitsDone));
      });

      test('the bloc instance is disposed when the scope is closed koin',
          () async {
        final scope = koin!.createScope<ScopeKey>('myScope');
        final bloc = scope.get<CounterCubit>();
        scope.close();

        await expectLater(bloc.stream, emits(emitsDone));
      });
    });
  });

  group('bloc ', () {
    group('shoud resolve', () {
      test('a single bloc', () {
        final bloc = koin!.get<CounterBloc>();
        expect(bloc, isNotNull);
      });

      test('shoud resolve a single bloc', () {
        final bloc = koin!.get<CounterBloc>();
        expect(bloc, isNotNull);
      });

      test('shoud resolve a scoped bloc', () {
        final scope = koin!.createScope<ScopeKey>('myScope');
        final bloc = scope.get<CounterBloc>();
        expect(bloc, isNotNull);
      });

      test('shoud resolve a scoped bloc - scopeOne', () {
        final scope = koin!.createScope<ScopeKey>('myScope');
        final bloc = scope.get<CounterBloc>();
        expect(bloc, isNotNull);
      });
    });

    group('shoud close', () {
      test('the single bloc definition when the stop koin', () async {
        final bloc = koin!.get<CounterBloc>();
        stopKoin();

        await expectLater(bloc.stream, emits(emitsDone));
      });

      test('the bloc instance is disposed when the scope is closed koin',
          () async {
        final scope = koin!.createScope<ScopeKey>('myScope');
        final bloc = scope.get<CounterBloc>();
        scope.close();

        await expectLater(bloc.stream, emits(emitsDone));
      });
    });
  });
}
