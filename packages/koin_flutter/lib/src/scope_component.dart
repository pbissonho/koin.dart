/*
 * Copyright 2019-2020 the original author or authors.
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

import 'package:flutter/widgets.dart';
import 'package:koin/koin.dart';

/*
 * Provide an scope for given State from a StatefulWidget
 *
 * @author Pedro Bissonho
 */
mixin ScopeComponent<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    createAndBindScope(getScopeId(), getScopeName());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Qualifier getScopeName() {
    return TypeQualifier(this.runtimeType);
  }

  String getScopeId() {
    return "${this.runtimeType}@${getScopeName().toString()}";
  }

  Scope getOrCreateCurrentScope() {
    var scopeId = getScopeId();
    var scope = getKoin().getScopeOrNull(scopeId);

    if (scope == null) {
      scope = createAndBindScope(scopeId, getScopeName());
    }
  }

  Scope createAndBindScope(String scopeId, Qualifier qualifier) {
    var scope = getKoin().createScope(scopeId, qualifier);
    // bindScope(scope);
    return scope;
  }

  /*
 * Get Koin context
 */
  Koin getKoin() {
    return GlobalContext.instance.get().koin;
  }

  /*
  * inject lazily given dependency for Android koincomponent
  * @param qualifier - bean qualifier / optional
  * @param scope
  * @param parameters - injection parameters
  */
  Lazy<T> inject<T>([Qualifier qualifier, DefinitionParameters parameters]) {
    return Lazy<T>(currentScope, qualifier, parameters);
    //return //= lazy { get<T>(qualifier, parameters) };
  }

  /*
  * get given dependency for Android koincomponent
  * @param name - bean name
  * @param scope
  * @param parameters - injection parameters
  */
  T get<T>(Qualifier qualifier, DefinitionParameters parameters) {
    return getKoin().get(qualifier, parameters);
  }

  /*
  * get given dependency for Android koincomponent, from primary and secondary types
  * @param name - bean name
  * @param scope
  * @param parameters - injection parameters
  */
  /*
  S bind<S, P>(DefinitionParameters parameters) {
    S = getKoin().bind<S, P>(parameters);
  }*/

  /*
  * Bind given scope to current LifecycleOwner
  * @param scope
  * @param event
  */
  /*
bindScope(scope: Scope, event: Lifecycle.Event = Lifecycle.Event.ON_DESTROY) {
    lifecycle.addObserver(ScopeObserver(event, this, scope))
}*/

  /*
  * Get current Koin scope, bound to current lifecycle
  */
  Scope get currentScope => getOrCreateCurrentScope();
}
