import 'package:koin/koin.dart';
import 'package:test/test.dart';

void main() {
  test('shoud be debug level', () {
    Logger loggerA = PrintLogger(Level.debug);
    expect(loggerA.level, Level.debug);
  });
}
