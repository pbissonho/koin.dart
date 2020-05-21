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

import 'package:equatable/equatable.dart';
import 'package:koin/koin.dart';

class CheckedComponent with EquatableMixin {
  final Qualifier qualifier;
  final Type type;
  CheckedComponent(this.qualifier, this.type);

  @override
  List<Object> get props => [type, qualifier];
}

class ParametersBinding {
  Map creators = HashMap<CheckedComponent, DefinitionParameters>();
  Koin koin;
  void create<T>(DefinitionParameters creator, {Qualifier qualifier}) {
    creators[CheckedComponent(qualifier, T)] = creator;
  }
}

typedef ParametersCreator = DefinitionParameters Function(Qualifier qualifier);

class CheckParameters extends ParametersBinding {}


CheckParameters checkParametersOf(Map<Type, DefinitionParameters> creators) {
  var checkParameters = CheckParameters();
  creators.forEach((type, creator) {
    checkParameters.creators[CheckedComponent(null, type)] = creator;
  });

  return checkParameters;
}
