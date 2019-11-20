abstract class KoinException implements Exception {
  final String msg;
  String get exceptionName;
  KoinException(this.msg);

  @override
  String toString() {
    return "$exceptionName: $msg";
  }
}

class BadScopeInstanceException extends KoinException {
  BadScopeInstanceException(String msg) : super(msg);

  String get exceptionName => "BadScopeInstanceException";
}

class IllegalStateException extends KoinException {
  IllegalStateException(String msg) : super(msg);

  String get exceptionName => "IllegalStateException";
}

class InstanceCreationException extends KoinException {
  // Todo
  // add a exception na message
  InstanceCreationException(String msg, Exception e) : super(msg);

  String get exceptionName => "InstanceCreationException";
}

class KoinAppAlreadyStartedException extends KoinException {
  KoinAppAlreadyStartedException(String msg) : super(msg);

  String get exceptionName => "KoinAppAlreadyStartedException";
}

class MissingPropertyException extends KoinException {
  MissingPropertyException(String msg) : super(msg);

  String get exceptionName => "MissingPropertyException";
}

class DefinitionOverrideException extends KoinException {
  DefinitionOverrideException(String msg) : super(msg);

  String get exceptionName => "DefinitionOverrideException";
}

class NoParameterFoundException extends KoinException {
  NoParameterFoundException(String msg) : super(msg);

  String get exceptionName => "NoParameterFoundException";
}

class NoBeanDefFoundException extends KoinException {
  NoBeanDefFoundException(String msg) : super(msg);

  String get exceptionName => "NoParameterFoundException";
}
