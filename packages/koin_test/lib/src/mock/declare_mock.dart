/*
 * Copyright 2019 the original author or authors.
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

/*
import 'package:koin/koin.dart';



/// Declare a Mock instance in Koin container for given type
///
/// @author Pedro Bissonho

T declareMock<T>(
  T stubbing, [
  Qualifier qualifier,
]) {
  var koin = GlobalContext.instance.get().koin;
  var type = T;

  var foundDefinition = getDefinition<T>(type, koin, qualifier);
  declareMockedDefinition(koin, foundDefinition, stubbing);

  return koin.get<T>(qualifier, null);
}

BeanDefinition<T> getDefinition<T>(Type type, Koin koin, Qualifier qualifier) {
  logger.info("declare mock for '${type}'");

  var definition = koin.rootScope.beanRegistry.findDefinition(qualifier, type);

  if (definition == null) {
    // TOdo
    // added NoBeanDefFoundException
    throw ("No definition found for qualifier='$qualifier' & type='$type'");
  }

  return definition;
}

void declareMockedDefinition<T>(
  Koin koin,
  BeanDefinition foundDefinition,
  T stubbing,
) {
  var definition = createMockedDefinition(stubbing, foundDefinition);
  koin.rootScope.beanRegistry.saveDefinition(definition);
}

BeanDefinition<T> createMockedDefinition<T>(
    T stubbing, BeanDefinition original) {
  BeanDefinition<T> copy;

  Definition<T> definition =
      (Scope scope, DefinitionParameters params) => stubbing;
  // var pairResult = Measure.measureDuration(() {
  //  return stubbing;
  // });

  // logger.debug("| mock created in ${pairResult.duration} ms");

  switch (original.kind) {
    case Kind.Single:
      copy = BeanDefinition<T>.createSingle(
          original.qualifier, original.scopeName, definition);
      break;
    case Kind.Factory:
      copy = BeanDefinition<T>.createFactory(
          original.qualifier, original.scopeName, definition);
      break;
    case Kind.Scoped:
      copy = BeanDefinition<T>.createScoped(
          original.qualifier, original.scopeName, definition);
      break;
  }

  copy.secondaryTypes = original.secondaryTypes;
  copy.options = Options(
      isCreatedAtStart: original.options.isCreatedAtStart, override: true);
  copy.createInstanceHolder();
  return copy;
}
*/