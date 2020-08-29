import '../../../instance_factory.dart';
import '../koin_application.dart';
import '../koin_dart.dart';
import '../logger.dart';

/*
 * Copyright 2017-2020 the original author or authors.
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

///
/// Component thath hold the Koin instance
///
abstract class KoinContext {
  ////
  ///Retrieve current KoinContext
  ///
  Koin get();

  ///
  /// Retrieve current KoinContext or null
  ///
  Koin getOrNull();

  ///
  /// sets up a Koin Application
  ///
  void setup(KoinApplication koinApplication);

  ///
  ///Stop current KoinContext
  ///
  void stop();
}

abstract class ScopeObserver {
  void onCreate();
  void onClose();
}

abstract class LoggerInstanceObserverBase {
  void onCreate(InstanceFactory instanceFactory);
  void onDispose(InstanceFactory instanceFactory);
  void onResolve(String type, String duration);
}

class LoggerInstanceObserver implements LoggerInstanceObserverBase {
  final Koin koin;

  LoggerInstanceObserver(this.koin);

  @override
  void onDispose(InstanceFactory instanceFactory) {
    koin.logger.isAtdebug(
        '''| dispose instance for ${instanceFactory.beanDefinition}''',
        Level.debug);
  }

  void onResolve(String type, String duration) {
    koin.logger.debug("+- get '${type.toString()} in $duration ms'");
  }

  @override
  void onCreate(InstanceFactory instanceFactory) {
    koin.logger.isAtdebug(
        '''| create instance for ${instanceFactory.beanDefinition}''',
        Level.debug);
  }
}
