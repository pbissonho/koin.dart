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

import 'context/context_handler.dart';
import 'definition/definition_parameter.dart';
import 'qualifier.dart';
import 'koin_dart.dart';
import 'lazy.dart';
import 'scope/scope.dart';

///
/// KoinComponentMixin interface marker to bring Koin extensions features
///
/// @author Arnaud Giuliani
///

mixin KoinComponentMixin {
  ///
  /// Get the associated Koin instance
  ///
  Koin getKoin() => KoinContextHandler.get();

  T get<T>([Qualifier qualifier]) {
    return getKoin().get<T>(qualifier);
  }

  T getWithParam<T, P>(P param, {Qualifier qualifier}) {
    return getKoin().getWithParam<T, P>(param);
  }

  ///
  /// Lazy inject instance from Koin
  /// @param qualifier
  /// @param parameters
  ///
  Lazy<T> inject<T>([Qualifier qualifier]) {
    return getKoin().inject<T>(qualifier);
  }

  ///
  /// Lazy inject instance from Koin
  ///
  Lazy<T> injectWithParam<T, P>(P param, {Qualifier qualifier}) {
    return getKoin().injectWithParam<T, P>(param, qualifier: qualifier);
  }

  ///
  /// Get instance instance from Koin by Primary Type P, as secondary type S
  /// @param parameters
  ///
  S bind<S, P>([Qualifier qualifier]) {
    return getKoin().bind<S, P>();
  }

  ///
  /// Get instance instance from Koin by Primary Type K, as secondary type S
  /// @param parameters
  ///
  /// TODO
  S bindWithParam<S, K, P>(
      {Qualifier qualifier, DefinitionParameter definitionParameter}) {
    return getKoin().bind<S, P>(qualifier);
  }
}

mixin ScopedComponentMixin {
  ///
  /// Get the associated Koin instance
  ///
  Scope componentScope();

  T get<T>([Qualifier qualifier]) {
    return componentScope().get<T>(qualifier);
  }

  T getWithParam<T, P>(P param, {Qualifier qualifier}) {
    return componentScope().getWithParam<T, P>(param);
  }

  ///
  /// Lazy inject instance from Koin
  /// @param qualifier
  /// @param parameters
  ///
  Lazy<T> inject<T>([Qualifier qualifier]) {
    return componentScope().inject<T>(qualifier);
  }

  ///
  /// Lazy inject instance from Koin
  ///
  Lazy<T> injectWithParam<T, P>(P param, {Qualifier qualifier}) {
    return componentScope().injectWithParam<T, P>(param, qualifier: qualifier);
  }

  ///componentScope
  /// Get instance instance from Koin by Primary Type P, as secondary type S
  /// @param parameters
  ///
  S bind<S, P>([Qualifier qualifier]) {
    return componentScope().bind<S, P>(qualifier);
  }

  ///
  /// Get instance instance from Koin by Primary Type K, as secondary type S
  /// @param parameters
  ///
  /// TODO
  S bindWithParam<S, K, P>(
      {Qualifier qualifier, DefinitionParameter definitionParameter}) {
    return componentScope().bind<S, P>();
  }
}

/// KoinComponent interface marker to bring Koin extensions features.
/// Koin is a DSL to help describe your modules & definitions, a container
/// to make definition resolution .What we need now is an API
/// to retrieve our instances outside of the container. That's the goal of Koin
/// components.
///## Create a Koin Component
///To give a class the capacity to use Koin features, we need to *tag it* with
///`KoinComponent` interface. Let's take an example.
/// A module to define MyService instance
///```dart
///class MyService {}
///var myModule = module()..single((s) => MyService());
///```
/// we start Koin before using definition.
/// Initializes koin with `startKoin`:
/// ```dart
/// void main(vararg args : String){
///    // Start Koin
///    startKoin((app){
///        app.module(myModule);
///    });
///
///    // Create MyComponent instance and inject from Koin container
///    MyComponent();
///}
///```
///
/// Here is how we can write our `MyComponent` to retrieve instances from
/// Koin container.
///
/// Use `get` & by `inject` to inject MyService instance:
///
///```dart
///class MyComponent extends View with KoinComponentMixin {
///  MyService myService;
///  Lazy<MyService> myServiceLazy;
///
///  MyComponent() {
///    // lazy inject Koin instance
///    myServiceLazy = inject<MyService>();
///    // or
///    // eager inject Koin instance
///    myService = get<MyService>();
///  }
///}
///```
/// ## Unlock the Koin API with KoinComponents
///
/// Once you have tagged your class as `KoinComponent`, you gain access to:
///
/// * `inject` - lazy evaluated instance from Koin container
/// * `get` - eager fetch instance from Koin container
///
/// ## Retrieving definitions with `get` & `inject`
/// Koin offers two ways of retrieving instances from the Koin container:
/// * `Lazy<T> t = inject<T>()` - lazy evaluated delegated instance
/// * `T t = get<T>()` - eager access for instance
///```dart
//  is lazy evaluated
/// Lazy<MyService> myService = inject();
/// retrieve directly the instance
/// MyService myService = get();
///```
/// The `lazy` inject form is better to define property that
/// need lazy evaluation.
/// ## Resolving instance from its name
/// If you need you can specify the following parameter with `get` or `inject`
/// * `qualifier` - name of the definition (when specified name parameter
///  in your definition)
/// Example of module using definitions names:
/// ```dart
/// class ComponentA {}
///
/// class ComponentB {
///  final ComponentA componentA;
///	///
/// KoinComponent interface marker to bring Koin extensions features	///  ComponentB(this.componentA);
///}
///	///
/// final myModule = module()
///  ..single((s) => ComponentA(), qualifier: named("A"))
///  ..single((s) => ComponentB(s.get()), qualifier: named("B"));
///```
/// We can make the following resolutions:
///```dart
/// retrieve from given module
/// var a = get<ComponentA>(named("A"))
///```
/// ## No inject() or get() in your API?
/// If your are using an API and want to use Koin inside it, just tag
/// the desired class with `KoinComponent` interface.
class KoinComponent with KoinComponentMixin {}
