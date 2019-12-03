/// Support for doing something awesome.
///
/// More dartdocs go here.
library koin_test;

export 'src/check/check_module_dsl.dart';
export 'src/check/check_modules.dart';
export 'src/module_test.dart';
import 'package:koin/koin.dart';

class KoinTest {
  /**
 * Declare component on the fly
 * @param moduleDeclaration lambda
 */
  static void declare(Module module) {
    GlobalContext.instance.get().module(module);
  }
}
