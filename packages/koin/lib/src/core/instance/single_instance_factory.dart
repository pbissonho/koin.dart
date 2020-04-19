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

import '../../koin_dart.dart';
import 'instance_context.dart';
import 'instance_factory.dart';

///
/// Single definition Instance holder
// @author Arnaud Giuliani
///
class SingleInstanceFactory<T> extends InstanceFactory<T> {
  SingleInstanceFactory(Koin koin, BeanDefinition<T> beanDefinition)
      : super(koin: koin, beanDefinition: beanDefinition);

  T _value;

  @override
  bool isCreated() => _value != null;

  @override
  void drop(InstanceContext context) {
    beanDefinition.callbacks.onCloseCallback(_value);
    _value = null;
  }

  @override
  T create(InstanceContext context) {
    if (_value == null) {
      var created = super.create(context);
      if (created == null) {
        error("Single instance created couldn't return value");
      }
      return created;
    } else {
      return _value;
    }
  }

  @override
  T get(InstanceContext context) {
    if (!isCreated()) {
      _value = create(context);
    }

    if (_value == null) {
      error("Single instance created couldn't return value");
    }

    return _value;
  }
}
