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
import 'definition/definitions.dart';
import 'scope/scope_definition.dart';
import 'definition/provider_definition.dart';
import 'definition/definition.dart';
import 'qualifier.dart';
import 'scope/scope_dsl.dart';

// ignore_for_file: avoid_positional_boolean_parameters

///
/// Gather/help compose Koin definitions
class Module {
  final bool createAtStart;
  final bool override;
  ScopeDefinition rootScope = ScopeDefinition.root();
  bool isLoaded = false;
  List<ScopeDefinition> scopeDefinitions = <ScopeDefinition>[];

  Module([this.createAtStart = false, this.override = false]);

  ///
  /// Declare a group a scoped definition with a given scope qualifier
  /// @param qualifier
  ///
  void scopeWithType(Qualifier qualifier, Function(ScopeDSL dsl) scopeCreate) {
    var scopeDefinition = ScopeDefinition(qualifier, isRoot: false);
    var scopeCreated = ScopeDSL(scopeDefinition);
    scopeCreate(scopeCreated);

    // ScopeDSL(scopeDefinition).apply(scopeSet);
    scopeDefinitions.add(scopeDefinition);
  }

  ///
  /// Class Typed Scope
  ///
  void scope<T>(Function(ScopeDSL dsl) makeScope) {
    var scopeDefinition = ScopeDefinition(TypeQualifier(T), isRoot: false);
    var scopeCreated = ScopeDSL(scopeDefinition);
    makeScope(scopeCreated);

    // ScopeDSL(scopeDefinition).apply(scopeSet);
    scopeDefinitions.add(scopeDefinition);
  }

  /// Declare in a simplified way a scope that has
  /// only one [definition].

  /// Declare a definition [T] for scope [TScope].
  /// Declare and define a scoped with just one line.

  ///
  ///Standard: Used when it is necessary to declare several
  ///definitions for a scope.
  ///```
  ///  ..scope<Login>((s) {
  ///  s.scopedBloc((s) => LoginBloc(s.get()));
  ///})
  ///```
  /// Declare a scope and define a scoped with just one line:
  ///```
  /// Module()..scopeOne<MyBloc, MyScope>((s) => MyBloc());
  ///```
  ProviderDefinition<T> scopeOne<T, TScope>(
    ProviderCreate<T> create, {
    Qualifier? qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    var scopeDefinition = ScopeDefinition(TypeQualifier(TScope), isRoot: false);
    scopeDefinitions.add(scopeDefinition);

    var beanDefinition = Definitions.saveSingle<T>(
        qualifier,
        ProviderCreateDefinition<T>(create),
        scopeDefinition,
        Options(isCreatedAtStart: createdAtStart, override: override));
    return beanDefinition;
  }

  ///
  /// Declare a Single definition
  ///
  ProviderDefinition<T> single<T>(
    ProviderCreate<T> create, {
    Qualifier? qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    return Definitions.saveSingle<T>(
        qualifier,
        ProviderCreateDefinition(create),
        rootScope,
        makeOptions(override: override, createdAtStart: createdAtStart));
  }

  ///
  /// Declare a Single definition
  ///
  ProviderDefinition<T> singleWithParam<T, A>(
    ProviderCreateParam<T, A> create, {
    Qualifier? qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    return Definitions.saveSingle<T>(
        qualifier,
        ProviderCreateParamDefinition<T, A>(create),
        rootScope,
        makeOptions(override: override, createdAtStart: createdAtStart));
  }

  Options makeOptions({bool override = false, bool createdAtStart = false}) {
    return Options(
        isCreatedAtStart: createAtStart || createdAtStart,
        override: this.override || override);
  }

  ///
  /// Declare a Factory definition
  ///
  ProviderDefinition<T> factory<T>(
    ProviderCreate<T> create, {
    Qualifier? qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    return Definitions.saveFactory<T>(
        qualifier,
        ProviderCreateDefinition<T>(create),
        rootScope,
        makeOptions(override: override));
  }

  ///
  /// Declare a Factory definition
  ///
  ProviderDefinition<T> factoryWithParam<T, A>(
    ProviderCreateParam<T, A> create, {
    Qualifier? qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    return Definitions.saveFactory<T>(
        qualifier,
        ProviderCreateParamDefinition<T, A>(create),
        rootScope,
        makeOptions(override: override));
  }

  List<Module> operator +(Module other) {
    return List.from([this, other]);
  }
}

///
/// Define a Module
/// @param createdAtStart
/// @param override
///
/// @author Arnaud Giuliani
///
Module module({
  bool createdAtStart = false,
  bool override = false,
}) {
  var module = Module(createdAtStart, override);
  return module;
}
