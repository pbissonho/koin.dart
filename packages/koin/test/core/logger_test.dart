import 'package:koin/koin.dart';
import 'package:test/test.dart';

void main() {
  test('shoud be debug level', () {
    Logger loggerA = Logger.print(Level.debug);
    expect(loggerA.level, Level.debug);
  });
}
