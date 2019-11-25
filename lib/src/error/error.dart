import 'package:koin/src/error/exceptions.dart';

void error(String msg) => Error.error(msg);

class Error {
  static error(String msg) {
    throw IllegalStateException(msg);
  }
}

class Intrinsics {
  static void checkParameterIsNotNull(dynamic value, String name) {
    if (value == null) {
      throw IllegalStateException("$name cannot be null.");
    }
  }
}
