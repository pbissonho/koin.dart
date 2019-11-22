import 'package:koin/src/core/qualifier.dart';
import 'package:test/test.dart';

class App {}

class Auth {}

enum Modules { app, auth }

void main() {
  test("type qualifier with class", () {
    Qualifier typedA = typed(Auth);
    Qualifier typedEquas = typed(Auth);
    Qualifier typedQ = typed(App);

    var notEquas = typedA == typedQ;
    expect(notEquas, false);

    var equas = typedA == typedEquas;
    expect(equas, true);

    expect("Auth", typedA.toString());
    expect("App", typedQ.toString());
  });

  test("type qualifier with enum", () {
    Qualifier typedA = typed(Modules.app);
    Qualifier typedEquas = typed(Modules.app);
    Qualifier typedQ = typed(Modules.auth);

    var notEquas = typedA == typedQ;
    expect(notEquas, false);

    var equas = typedA == typedEquas;
    expect(equas, true);

    expect("Modules.app", typedA.toString());
    expect("Modules.auth", typedQ.toString());
  });
  test("string qualifier ", () {
    Qualifier typedA = named("App");
    Qualifier typedEquas = named("App");
    Qualifier typedQ = named("Auth");

    var notEquas = typedA == typedQ;
    expect(notEquas, false);

    var equas = typedA == typedEquas;
    expect(equas, true);

    expect("App", typedA.toString());
    expect("Auth", typedQ.toString());
  });
}
