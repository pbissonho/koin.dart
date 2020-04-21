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
import 'package:koin/src/core/definition/definitions.dart';
import 'package:koin/src/core/scope/scope_definition.dart';
import 'package:kt_dart/kt.dart';
import 'definition/bean_definition.dart';
import 'definition/options.dart';
import 'qualifier.dart';

///
/// Koin Module
/// Gather/help compose Koin definitions
/// @author - Arnaud GIULIANI
///
/// Ported to Dart from Kotlin by:
/// @author - Pedro Bissonho
///
class Module {
  final bool createAtStart;
  final bool override;
  ScopeDefinition rootScope = ScopeDefinition.rootDefinition();
  bool isLoaded = false;
  var otherScopes = KtList<ScopeDefinition>.empty();

  Module([this.createAtStart, this.override]);

  /*
  ///
     /// Declare a group a scoped definition with a given scope qualifier
     /// @param qualifier
     ///
    void scopeQ(Qualifier qualifier, scopeSet: ScopeDSL.() -> Unit) {
        var scopeDefinition = ScopeDefinition(qualifier);
        ScopeDSL(scopeDefinition).apply(scopeSet);
        otherScopes.add(scopeDefinition);
    }

    ///
    ///Class Typed Scope
    ///
    void <T> scope(scopeSet: ScopeDSL.() -> Unit) {
        var scopeDefinition = ScopeDefinition(TypeQualifier(T));
        ScopeDSL(scopeDefinition).apply(scopeSet);
        otherScopes.add(scopeDefinition);
    }
*/

  ///
  /// Declare a Single definition
  ///
  BeanDefinition<T> single<T>(
    Definition<T> definition, {
    Qualifier qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    return Definitions.saveSingle(qualifier, definition, rootScope,
        makeOptions(override, createdAtStart));
  }

  Options makeOptions(bool override, [bool createdAtStart = false]) {
    return Options(
        isCreatedAtStart: createAtStart || createdAtStart,
        override: this.override || override);
  }

  ///
  /// Declare a Factory definition
  ///
  BeanDefinition<T> factory<T>(
    Definition<T> definition, {
    Qualifier qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    return Definitions.saveFactory(
        qualifier, definition, rootScope, makeOptions(override));
  }

  // TODO

  /*

   ///
    /// Help write list of Modules
     ///
    operator fun plusModule(module: Module) = listOf(this, module)

    ///
     /// Help write list of Modules
     ///
    operator fun plusModules(modules: List<Module>) = listOf(this) + modules
    */

}

///
/// Define a Module
///
Module module({bool createdAtStart = false, bool override = false}) {
  var module = Module(createdAtStart, override);
  return module;
}
