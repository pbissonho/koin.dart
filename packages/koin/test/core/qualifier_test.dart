import 'package:koin/src/core/qualifier.dart';
import 'package:test/test.dart';

class App {}

class Auth {}

enum Modules { app, auth }

void main() {
  test("type qualifier with class", () {
    Qualifier typedA = qualifier<Auth>();
    Qualifier typedEquas = qualifier<Auth>();
    Qualifier typedQ = qualifier<App>();

    var notEquas = typedA == typedQ;
    expect(notEquas, false);

    var equas = typedA == typedEquas;
    expect(equas, true);

    expect("Auth", typedA.toString());
    expect("App", typedQ.toString());
  });
  /*
  test("type qualifier with enum", () {
    Qualifier typedA = qualifier(Modules.app);
    Qualifier typedEquas = qualifier(Modules.app);
    Qualifier typedQ = qualifier(Modules.auth);

    var notEquas = typedA == typedQ;
    expect(notEquas, false);

    var equas = typedA == typedEquas;
    expect(equas, true);

    expect("Modules.app", typedA.toString());
    expect("Modules.auth", typedQ.toString());
  });
*/

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
