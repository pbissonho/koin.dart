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

import 'dart:core';
import 'package:koin/src/error/exceptions.dart';

/*
 * DefinitionParameters - Parameter holder
 * Usable with exploded declaration
 *
 * @author - Arnaud GIULIANI
 * 
 * Ported to Dart from Kotlin by:
 * @author - Pedro Bissonho 
 */

class DefinitionParameters {
  final List<Object> _values;

  static final int maxParams = 5;

  DefinitionParameters(this._values) {
    if (_values.length > maxParams) {
      throw IllegalStateException(
          "Can't build DefinitionParameters for more than 5 arguments");
    }
  }

  Object elementAt(int i) {
    if (this._values.length > i) {
      return this._values[i];
    } else {
      throw NoParameterFoundException(
          "Can't get parameter value $i from $this");
    }
  }

  Object component1() => elementAt(0);
  Object component2() => elementAt(1);
  Object component3() => elementAt(2);
  Object component4() => elementAt(3);
  Object component5() => elementAt(4);

  /// get element at given index
  /// return T
  ///
  Object get(int index) {
    var object = elementAt(index);
    return object;
  }

  ///
  /// Number of contained elements
  ///
  int size() => _values.length;

  ///
  /// Tells if it has parameters
  ///
  bool isEmpty() => size() == 0;

  ///
  /// Tells if it has parameters
  ///
  bool isNotEmpty() => !isEmpty();

  ///
  /// Get first element of given type [T]
  /// return [T]
  ///
  Object getWhere<T>() => _values.firstWhere((value) => value is T);
}

///
/// Build a `DefinitionParameters`
///
/// @see `DefinitionParameters`
/// return ParameterList
///
DefinitionParameters parametersOf(List<Object> parameters) {
  if (parameters != null) {
    return DefinitionParameters(parameters);
  }

  return emptyParametersHolder();
}

DefinitionParameters emptyParametersHolder() =>
    DefinitionParameters(<Object>[]);
