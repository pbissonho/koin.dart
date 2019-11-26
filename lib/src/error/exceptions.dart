/*
 * Copyright 2017-2018 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

abstract class KoinException implements Exception {
  final String msg;
  KoinException(this.msg);

  @override
  String toString() {
    return "${this.runtimeType}: $msg";
  }
}

class BadScopeInstanceException extends KoinException {
  BadScopeInstanceException(String msg) : super(msg);
}

class IllegalStateException extends KoinException {
  IllegalStateException(String msg) : super(msg);
}

class InstanceCreationException extends KoinException {
  Exception e;

  InstanceCreationException(String msg, this.e) : super(msg);

  @override
  String get msg => "${super.msg}  ${e.toString()}";
}

class KoinAppAlreadyStartedException extends KoinException {
  KoinAppAlreadyStartedException(String msg) : super(msg);
}

class MissingPropertyException extends KoinException {
  MissingPropertyException(String msg) : super(msg);
}

class DefinitionOverrideException extends KoinException {
  DefinitionOverrideException(String msg) : super(msg);
}

class NoParameterFoundException extends KoinException {
  NoParameterFoundException(String msg) : super(msg);
}

class NoBeanDefFoundException extends KoinException {
  NoBeanDefFoundException(String msg) : super(msg);
}

class ScopeNotCreatedException extends KoinException {
  ScopeNotCreatedException(String msg) : super(msg);
}

class ScopeAlreadyCreatedException extends KoinException {
  ScopeAlreadyCreatedException(String msg) : super(msg);
}

class NoScopeDefinitionFoundException extends KoinException {
  NoScopeDefinitionFoundException(String msg) : super(msg);
}
