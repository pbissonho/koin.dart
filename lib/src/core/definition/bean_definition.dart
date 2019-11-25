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
import 'package:equatable/equatable.dart';
import 'package:koin/src/core/definition/properties.dart';
import 'package:koin/src/core/definition_parameters.dart';
import 'package:koin/src/core/instance/definition_instance.dart';

import '../qualifier.dart';
import 'options.dart';

typedef T OnReleaseCallback<T>(T value);
typedef void OnCloseCallback<T>(T value);
typedef T Definition<T>(Scope scope, DefinitionParameters parameters);

enum Kind {
  Single,
  Factory,
  Scoped,
}

/*
 * Koin bean definition
 * main structure to make definition in Koin
 * @author - Arnaud GIULIANI
 * 
 * Ported to Dart from Kotlin by:
 * @author - Pedro Bissonho 
 */
class BeanDefinition<T> with EquatableMixin {
  DefinitionInstance<T> _instance;

  final Definition<T> definition;

  Options _options;

  Properties _properties;

  final Kind kind;

  OnReleaseCallback<T> _onRelease;

  OnCloseCallback<T> _onClose;

  final Qualifier qualifier;

  final Qualifier scopeName;

  final Type primaryType;

  var secondaryTypes = <Type>[];

  @override
  List<Object> get props => [qualifier, primaryType];

  BeanDefinition(this.qualifier, this.scopeName, this.kind, this.definition)
      : primaryType = T;

  BeanDefinition.completed(this.qualifier, this.scopeName, this.primaryType,
      {this.definition, this.kind}) {
    // Intrinsics.checkParameterIsNotNull(primaryType, "primaryType");
    this.secondaryTypes = List<Type>();
    this._options = Options(isCreatedAtStart: false, override: false);
    this._properties = Properties();
  }

  factory BeanDefinition.createSingle(
      Qualifier qualifier, Qualifier scopeName, Definition<T> definition) {
    return BeanDefinition<T>(qualifier, scopeName, Kind.Single, definition);
  }

  factory BeanDefinition.createFactory(
      Qualifier qualifier, Qualifier scopeName, Definition<T> definition) {
    return BeanDefinition<T>(qualifier, scopeName, Kind.Factory, definition);
  }
  factory BeanDefinition.createScoped(
      Qualifier qualifier, Qualifier scopeName, Definition<T> definition) {
    return BeanDefinition<T>(qualifier, scopeName, Kind.Scoped, definition);
  }

  List<Type> getSecondaryTypes() {
    return this.secondaryTypes;
  }

  void setSecondaryTypes(List<Type> secondarysTypes) {
    // Intrinsics.checkParameterIsNotNull(var1, "<set-?>");
    this.secondaryTypes = secondarysTypes;
  }

  DefinitionInstance<T> getInstance() {
    return this._instance;
  }

  void setInstance(DefinitionInstance<T> instance) {
    this._instance = instance;
  }

  OnReleaseCallback<T> getOnRelease() {
    return this._onRelease;
  }

  void setOnRelease(OnReleaseCallback<T> onRelease) {
    this._onRelease = onRelease;
  }

  OnCloseCallback<T> getOnClose() {
    return this._onClose;
  }

  void setOnClose(OnCloseCallback<T> onclose) {
    this._onClose = onclose;
  }

  bool hasScopeSet() {
    return this.scopeName != null;
  }

  /**
     * Create the associated Instance Holder
     */
  void createInstanceHolder() {
    if (kind == null) {
      // Intrinsics.throwUninitializedPropertyAccessException("kind");
    }

    switch (kind) {
      case Kind.Single:
        _instance = DefinitionInstance.single(this);
        break;
      case Kind.Factory:
        _instance = DefinitionInstance.factory(this);
        break;
      case Kind.Scoped:
        _instance = DefinitionInstance.scoped(this);
        break;
    }
  }

  /**
     * Resolve instance
     */
  T resolveInstance(InstanceContext context) {
    //Intrinsics.checkParameterIsNotNull(context, "context");

    if (_instance != null) {
      T value = _instance.get(context);
      if (value != null) {
        return value;
      }
    }

    /*
    String message = "Definition without any InstanceContext -  $this";
    throw IllegalStateException(message);
    */
  }

  void close() {
    if (_instance != null) {
      _instance.close();
    }

    this._instance = null;
  }

  BeanDefinition<T> bind(Type type) {
    this.secondaryTypes.add(type);
    return this;
  }

  BeanDefinition<T> binds(List<Type> types) {
    this.secondaryTypes.addAll(types);
    return this;
  }

  BeanDefinition<T> onRelease(OnReleaseCallback<T> onRelease) {
    _onRelease = onRelease;
    return this;
  }

  BeanDefinition<T> onClose(OnCloseCallback<T> onClose) {
    _onClose = onClose;
    return this;
  }
}
