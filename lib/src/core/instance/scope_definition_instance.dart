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

import 'package:koin/src/core/definition/bean_definition.dart';
import 'package:koin/src/error/exceptions.dart';
import 'definition_instance.dart';

/**
 * Scope definition Instance holder
 * @author Arnaud Giuliani
 */
class ScopeDefinitionInstance<T> extends DefinitionInstance<T> {
  ScopeDefinitionInstance(BeanDefinition<T> beanDefinition)
      : super(beanDefinition);

  Map<String, T> _values = Map<String, T>();

  T get(InstanceContext context) {
    if (context.koin == null) {
      throw IllegalStateException(
          "ScopeDefinitionInstance has no registered Koin instance");
    }

    if (context.scope == context.koin.rootScope) {
      throw ScopeNotCreatedException(
          "No scope instance created to resolve $beanDefinition");
    }

    if (context.scope == null) {
      throw ("ScopeDefinitionInstance has no scope in context");
    }

    checkScopeResolution(beanDefinition, context.scope);

    String internalId = context.scope.id;

    var current = _values[internalId];
    if (current == null) {
      current = create(context);

      if (current == null) {
        throw ("Instance creation from $beanDefinition should not be null.");
      }

      _values[internalId] = current;
    }
    return current;
  }

  @override
  bool isCreated(InstanceContext context) {
    Intrinsics.checkParameterIsNotNull(context, "context");
    if (context.scope != null) {
      return _values[context.scope.id] != null;
    } else {
      return false;
    }
  }

  @override
  void release(InstanceContext context) {
    var scope = context.scope;

    if (scope == null) {
      throw ("ScopeDefinitionInstance has no scope in context");
    }

    /*
    if (logger.isAt(Level.DEBUG)) {
        logger.debug("releasing '$scope' ~ $beanDefinition ")
    }*/

    OnReleaseCallback<T> onRelease = beanDefinition.getOnRelease();

    T value = _values[scope.id];
    onRelease(value);
    _values.remove(scope.id);
  }

  @override
  void close() {
    Function onClose = beanDefinition.getOnClose();
    onClose();
    _values.clear();
  }
}

class Intrinsics {
  static void checkParameterIsNotNull(dynamic value, String s) {
    if (value == null) {
      throw "";
    }
  }
}
