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

/// DefinitionParameters - Parameter holder
///
/// Usable with exploded declaration
///
class Parameter<T> {
  final T parameter;

  const Parameter(this.parameter);

  T get() => parameter;
}

///
/// Builds a [DefinitionParameters] with a null element.
///
Parameter emptyParameter() => Parameter(null);
