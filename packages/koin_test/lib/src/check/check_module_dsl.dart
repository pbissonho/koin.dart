/*
 * Copyright 2017-2019 the original author or authors.
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

import 'package:koin/koin.dart';
import 'package:koin/internals.dart';

class CheckedComponent {
  final Qualifier? qualifier;
  final Type type;
  CheckedComponent(this.qualifier, this.type);

  @override
  int get hashCode => type.hashCode ^ qualifier.hashCode;

  @override
  bool operator ==(other) {
    return other is CheckedComponent &&
        other.qualifier == qualifier &&
        other.type == type;
  }
}

class CheckParameters {
  final Map<CheckedComponent, Parameter> creators =
      HashMap<CheckedComponent, Parameter>();

  void create<T, P>(P param, {Qualifier? qualifier}) {
    creators[CheckedComponent(qualifier, T)] = Parameter<P>(param);
  }

  void addAll(Map<CheckedComponent, Parameter<dynamic>>? other) {
    if (other != null) {
      creators.addAll(other);
    }
  }
}

typedef ParameterCreator = Parameter Function(Qualifier qualifier);

CheckParameters checkParametersOf(Map<Type, dynamic> creators) {
  var checkParameters = CheckParameters();
  creators.forEach((type, creator) {
    checkParameters.creators[CheckedComponent(null, type)] = Parameter(creator);
  });

  return checkParameters;
}
