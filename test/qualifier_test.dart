import 'package:koin/src/core/qualifier.dart';
import 'package:test/test.dart';

class App {}

enum Modules { app, auth }

void main() {
  test("qualifier", () {
    Qualifier qualifier = StringQualifier("app");
    expect("app", qualifier.toString());
  });

  test("type qualifier", () {
    Qualifier qualifier = TypeQualifier(App);
    print(qualifier);
    expect("App", qualifier.toString());
  });

  test("type qualifier", () {
    Qualifier namedQ = named("App");
    Qualifier typedQ = typed(App);
    expect("App", namedQ.toString());
    expect("App", typedQ.toString());
  });
}
