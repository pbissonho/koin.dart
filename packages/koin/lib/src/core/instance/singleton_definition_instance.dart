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
import 'package:koin/src/core/error/error.dart';
import 'definition_instance.dart';

///
/// Single definition Instance holder
// @author Arnaud Giuliani
///
class SingleDefinitionInstance<T> extends DefinitionInstance<T> {
  SingleDefinitionInstance(BeanDefinition<T> beanDefinition)
      : super(beanDefinition);

  T _value;

  @override
  void close() {
    var onClose = beanDefinition.getOnClose;
    if (onClose != null) {
      onClose(_value);
      _value = null;
    }
  }

  @override
  T get(InstanceContext context) {
    if (_value != null) {
      return _value;
    }

    _value = create(context);

    if (_value == null) {
      error("Single instance created couldn't return value");
    }

    return _value;
  }

  @override
  bool isCreated(InstanceContext context) => _value != null;

  @override
  void release(InstanceContext context) {}
}
