/*
 * Copyright 2017-2018 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import '../definition/bean_definition.dart';
import '../error/exceptions.dart';
import '../koin_dart.dart';
import '../logger.dart';
import 'instance_context.dart';

///
/// Koin Instance Holder
/// create/get/release an instance of given definition
///
abstract class InstanceFactory<T> {
  final Koin koin;
  final BeanDefinition<T> beanDefinition;

  InstanceFactory({this.koin, this.beanDefinition});

  ///
  /// Retrieve an instance
  /// @param context
  /// @return T
  ///
  T get(InstanceContext context);

  ///
  /// Create an instance
  /// @param context
  /// @return T
  ///
  T create(InstanceContext context) {
    logger.isAtdebug('| create instance for $beanDefinition', Level.debug);

    try {
      final parameters = context.parameters;
      return beanDefinition.definition.create(parameters, context.scope);
    } catch (erro) {
      logger.error('''
Instance creation error : could not create instance for $beanDefinition: ${erro.toString()}''');
      throw InstanceCreationException(
          'Could not create instance for $beanDefinition', erro.toString());
    }
  }

  ///
  /// Release the held instance (if hold)
  ///
  void drop();
}
