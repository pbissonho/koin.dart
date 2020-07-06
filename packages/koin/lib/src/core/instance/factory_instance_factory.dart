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

import '../definition/bean_definition.dart';

import '../koin_dart.dart';
import 'instance_context.dart';
import 'instance_factory.dart';

//
/// Factory Instance Holder
///
// @author Arnaud Giuliani
//
class FactoryInstanceFactory<T> extends InstanceFactory<T> {
  FactoryInstanceFactory(Koin koin, BeanDefinition<T> beanDefinition)
      : super(koin: koin, beanDefinition: beanDefinition);
  @override
  void drop() {
    beanDefinition.callbacks.runCallback(null);
  }

  @override
  T get(InstanceContext context) {
    return create(context);
  }
}
