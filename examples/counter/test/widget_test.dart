// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:koin/koin.dart';
import 'package:riverpod/riverpod.dart';

class MyClasse {}

class MyClasse2 {
  final MyClasse myClasse;

  MyClasse2(this.myClasse);
}

class MyClasse3 {
  final MyClasse myClasse;
  final MyClasse2 myClasse2;

  MyClasse3(this.myClasse, this.myClasse2);
}

class MyClasse4 {}

class MyClasse5 {}

GetIt getIt = GetIt.instance;

final helloWorldProvider = Provider((_) => MyClasse());
final helloWorldProvider2 =
    Provider((ref) => MyClasse2(ref.read(helloWorldProvider)));
final helloWorldProvider3 = Provider((ref) =>
    MyClasse3(ref.read(helloWorldProvider), ref.read(helloWorldProvider2)));
final helloWorldProvider4 = Provider((_) => MyClasse4());
final helloWorldProvider5 = Provider((_) => MyClasse5());

void main() {
  final container = ProviderContainer();
  test('Counter increments smoke test', () async {
    List<double> getItResult = [];
    List<double> koinResult = [];
    List<double> riverPodResult = [];

    final vezes = 100;

    double koinFinalResult = 0;
    double getItFinalResult = 0;
    double riverFinalResult = 0;

    final xkoinApplication = startKoin((app) {
      app.emptyInstanceLoggerObserver();
      app.logger(EmptyLogger(Level.none));
      app.module((Module()
        ..single((s) => MyClasse())
        ..single((s) => MyClasse2(s.get()))
        ..single((s) => MyClasse3(s.get(), s.get()))
        ..single((s) => MyClasse4())
        ..single((s) => MyClasse5())));
    });

    getIt.registerLazySingleton(() => MyClasse());
    getIt.registerLazySingleton(() => MyClasse2(getIt.get()));
    getIt.registerLazySingleton(() => MyClasse3(getIt.get(), getIt.get()));
    getIt.registerLazySingleton(() => MyClasse4());
    getIt.registerLazySingleton(() => MyClasse5());

    final myClasse = getIt.get<MyClasse>();
    final myClasse2 = getIt.get<MyClasse2>();
    final myClasse3 = getIt.get<MyClasse3>();
    final myClasse4 = getIt.get<MyClasse4>();
    final myClasse5 = getIt.get<MyClasse5>();

    final value1 = container.read(helloWorldProvider);
    final value2 = container.read(helloWorldProvider2);
    final value3 = container.read(helloWorldProvider3);
    final value4 = container.read(helloWorldProvider4);
    final value5 = container.read(helloWorldProvider5);
    
    final myClasseKoin = xkoinApplication.koin.get<MyClasse>();
    final myClasseKoin2 = xkoinApplication.koin.get<MyClasse2>();
    final myClasseKoin3 = xkoinApplication.koin.get<MyClasse3>();
    final myClasseKoin4 = xkoinApplication.koin.get<MyClasse4>();
    final myClasseKoin5 = xkoinApplication.koin.get<MyClasse5>();
    for (var i = 0; i < vezes; i++) {
      double getItDuration = measureDuration(() {
        final myClasse = getIt.get<MyClasse>();
        final myClasse2 = getIt.get<MyClasse2>();
        final myClasse3 = getIt.get<MyClasse3>();
        final myClasse4 = getIt.get<MyClasse4>();
        final myClasse5 = getIt.get<MyClasse5>();
      });

      getItResult.add(getItDuration);

      double koinDuration = measureDuration(() {
        final myClasseKoin = xkoinApplication.koin.get<MyClasse>();
        final myClasseKoin2 = xkoinApplication.koin.get<MyClasse2>();
        final myClasseKoin3 = xkoinApplication.koin.get<MyClasse3>();
        final myClasseKoin4 = xkoinApplication.koin.get<MyClasse4>();
        final myClasseKoin5 = xkoinApplication.koin.get<MyClasse5>();
      });

      koinResult.add(koinDuration);

      double riverDuration = measureDuration(() {
        final value1 = container.read(helloWorldProvider);
        final value2 = container.read(helloWorldProvider2);
        final value3 = container.read(helloWorldProvider3);
        final value4 = container.read(helloWorldProvider4);
        final value5 = container.read(helloWorldProvider5);
      });

      riverPodResult.add(riverDuration);
    }

    koinResult.forEach((element) => koinFinalResult += element);
    getItResult.forEach((element) => getItFinalResult += element);
    riverPodResult.forEach((element) => riverFinalResult += element);
    // Verify that our counter has incremented.

    koinFinalResult = koinFinalResult / vezes;
    getItFinalResult = getItFinalResult / vezes;
    riverFinalResult = riverFinalResult / vezes;

    print('Koin: $koinFinalResult ms');
    print('GetIt: $getItFinalResult ms');
    print('River: $riverFinalResult ms');

    xkoinApplication.close();
  });
}

double measureDuration(void Function() function) {
  var start = Stopwatch()..start();
  function();
  var result = start.elapsed.inMicroseconds.toDouble();
  return result;
}
