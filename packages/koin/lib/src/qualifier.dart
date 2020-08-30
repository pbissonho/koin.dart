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
 * */

///
/// Qualifier
///
/// @author - Arnaud GIULIANI
///
/// Ported to Dart from Kotlin by:
/// @author - Pedro Bissonho
///
import 'package:equatable/equatable.dart';

/// Help qualify a component
abstract class Qualifier {
  final String _value;

  /// Get the qualifier value.
  String get value => _value;

  /// Help qualify a component
  Qualifier(this._value);
}

/// Give a String qualifier
Qualifier named<T>([String name]) {
  if (name == null) {
    return TypeQualifier(T);
  }
  return StringQualifier(name);
}

/// Give a String qualifier
Qualifier qualifier<T>([String name]) {
  if (name == null) {
    return TypeQualifier(T);
  }
  return StringQualifier(name);
}

/// String Qualifier
class StringQualifier extends Qualifier with EquatableMixin {
  /// String Qualifier
  StringQualifier(String value) : super(value);

  @override
  String toString() {
    return _value;
  }

  @override
  List<Object> get props => [_value];
}

/// Type Qualifier
class TypeQualifier<T> extends Qualifier with EquatableMixin {
  final T _type;

  /// Type Qualifier
  TypeQualifier(this._type) : super('q:$_type');

  @override
  String toString() {
    return _type.toString();
  }

  @override
  List<Object> get props => [_type];
}
