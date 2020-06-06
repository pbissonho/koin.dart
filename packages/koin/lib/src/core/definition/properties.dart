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

import 'dart:collection';

import '../error/exceptions.dart';

///
/// Definitions Properties
// @author - Arnaud GIULIANI
//
// Ported to Dart from Kotlin by:
// @author - Pedro Bissonho
//
class Properties {
  final HashMap<String, dynamic> _data = HashMap<String, dynamic>();

  void set<T>(String key, T value) {
    _data[key] = value;
  }

  T getOrNull<T>(String key) {
    return _data[key] as T;
  }

  T get<T>(String key) {
    var value = _data[key];

    if (value != null) {
      return value;
    } else {
      throw MissingPropertyException('Missing property for $key');
    }
  }
}
