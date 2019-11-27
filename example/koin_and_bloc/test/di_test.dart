import 'package:flutter_test/flutter_test.dart';
import 'package:koin/koin.dart';
import 'package:koin_and_bloc/di.dart';

void main() {
  test("description", () {
    var app = startKoin((app) {
      app.modules([appModule, otherModule]);
    });

    var scope = GlobalContext.instance.app.koin
        .createScope("test", named("CounterScopePage"));

    Teste teste = scope.inject<Teste>();

    Teteca teteca = app.koin.rootScope.get<Teteca>();

    expect(teste, isNotNull);
    expect(teteca, isNotNull);
  });
}
