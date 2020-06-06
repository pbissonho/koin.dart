import 'package:koin/src/core/qualifier.dart';
import 'package:test/test.dart';

class App {}

class Auth {}

enum Modules { app, auth }

void main() {
  test('type qualifier with class', () {
    var typedA = qualifier<Auth>();
    var typedEquas = qualifier<Auth>();
    var typedQ = qualifier<App>();

    var notEquas = typedA == typedQ;
    expect(notEquas, false);

    var equas = typedA == typedEquas;
    expect(equas, true);

    expect('Auth', typedA.toString());
    expect('App', typedQ.toString());
  });

  test('string qualifier ', () {
    var typedA = named('App');
    var typedEquas = named('App');
    var typedQ = qualifier('Auth');

    var notEquas = typedA == typedQ;
    expect(notEquas, false);

    var equas = typedA == typedEquas;
    expect(equas, true);

    expect('App', typedA.toString());
    expect('Auth', typedQ.toString());
  });
}
