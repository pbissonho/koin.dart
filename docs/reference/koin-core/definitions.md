# Definitions




By using Koin, you describe definitions in modules. In this section we will see how to declare, organize & link your modules.

## Writing a module

A Koin module is the space to declare all your components. Use the `module` function to declare a Koin module:

```dart
final myModule = module();// your dependencies here
// Or
final myModule2 = Module();// your dependencies here
```

In this module, you can declare components as described below.

## Defining a singleton

Declaring a singleton component means that Koin container will keep a *unique instance* of yBy using Koin, you describe definitions in modules. In this section we will see how to declare, organize & link your modules.

```dart
// declare single instance for MyService class
final myModule = module()..single((s) => MyService());
```

## Defining your component within a lambda

`single`, `factory` & `scoped` keywords help you declare your components through a lambda expression. this lambda describe
the way that you build your component. 

`..single((s) => MyClass())`

The result type of your lambda is the main type of your component

## Defining a factory

A factory component declaration is a definition that will gives you a *new instance each time* you ask for this definition (this instance is not retrained by Koin container, as it won't inject this instance in other definitions later). Use the `factory` function with a lambda expression to build a component.

```dart
class Controller {}

// declare factory instance for Controller class
final myModule = module()..factory((s) => Controller());
```
Koin container doesn't retain factory instances as it will give a new instance each time the definition is asked

## Resolving & injecting dependencies

Now that we can declare components definitions, we want to link instances with dependency injection. To *resolve an instance* in a Koin module, just use the `get()`
function to the requested needed component instance. This `get()` function is usually used into constructor, to inject constructor values.

To make dependency injection with Koin container, we have to write it in *constructor injection* style: resolve dependencies in class constructors. This way, your instance will be created with injected instances from Koin.


Let's take an example with several classes:

```dart
class Service {}

class Controller {
  final View controller;

  Controller(this.controller);
}

class View {}

// declare factory instance for Controller class
final myModule = module()
  // declare Service as single instance
  ..single((s) => Service())
  // declare Controller as single instance, resolving View instance with get()
  ..single((s) => Controller(s.get()));
```

## Definition: binding an interface

A `single` or a `factory` definition use the type from the their given lambda definition: i.e  `single { T }`
The matched type of the definition is the only matched type from this expression.

Let's take an example with a class and implemented interface:

```dart
// Service interface
abstract class Service {
  void doSomething();
}
// Service Implementation
class ServiceImp implements Service {
  void doSomething(){}
}```

In a Koin module we can use the `as` cast Dart operator as follow:

```dart
final myModule = module()
  // Will match type ServiceImp only
  ..single((s) => ServiceImp())
  // Will match type Service only
  ..single((s) => ServiceImp() as Service);
```

You can also use the inferred type expression:

```dart
final myModule = module()
  // Will match type ServiceImp only
  ..single((s) => ServiceImp())
  // Will match type Service only
  ..single<Service>((s) => ServiceImp());
```
This 2nd way of style declaration is preferred and will be used for the rest of the documentation.

## Additional type binding

In some cases, we want to match several types from just one definition.

Let's take an example with a class and interface:

```dart
// Service interface
abstract class Service {
  void doSomething();
}
// Service Implementation
class ServiceImp implements Service {
  void doSomething(){}
}```


To make a definition bind additional types, we use the `bind` operator with a Type:

```dart
var myModule = module()
  // Will match types ServiceImp & Service
  ..single((s) => ServiceImp()).bind<Service>();
```

Note here, that we would resolve the `Service` type directly with `get()`. But if we have multiple definitions binding `Service`, we have to use the `bind<>()` function.

## Definition: naming & default bindings

You can specify a name to your definition, to help you distinguish two definitions about the same type:

Just request your definition with its name:

```dart
var myModule = module()
  ..single<Service>((s) => ServiceImp(), qualifier: named("default"))
  ..single<Service>((s) => ServiceImp(), qualifier: named("test"));

var service = get(named("default"));
```

`get()` let you specify a definition name if needed. This name is a `qualifier` produced by the `named()` function.

By default Koin will bind a definition by its type or by its name, if the type is already bound to a definition.

```dart
var myModule = module()
  ..single<Service>((s) => ServiceImpl1())
  ..single<Service>((s) => ServiceImpl2(), qualifier: named("test"));
```

Then:

- `var service = get()` will trigger the `ServiceImpl1` definition
- `var service = get(named("test"))()` will trigger the `ServiceImpl2` definition


## Declaring injection parameters

In any `single`, `factory` or `scoped` definition, you can use injection parameters: parameters that will be injected and used by your definition:

```dart
class MySingle {
  final int value;

  MySingle(this.value);
}

var myModule = module()
  ..single1<MySingle,int>((s, value) => MySingle(value));
```

In contrary to resolved dependencies (resolved with `get()`), injection parameters are *parameters passed through the resolution API*.
This means that those parameters are values passed with `get()` and `by inject()`, with the `parametersOf` function:


```dart
var mySingle = getWithParams<MySingle>(parameters: parametersOf([10]));
```


## Using definition flags

Koin DSL also proposes some flags.

### Create instances at start

A definition or a module can be flagged as `createdAtStart`, to be created at start (or when you want). First set the `createdAtStart` flag on your module
or on your definition.


CreateAtStart flag on a definition

```dart
final moduleA = module()
  ..single<Service>((s) => ServiceImp());
final moduleB = module()
    // eager creation for this definition
  ..single<Service>((s) => TestServiceImp(), createdAtStart: true);
```

CreateAtStart flag on a module

```dart
final moduleA = module()
  ..single<Service>((s) => ServiceImp());
final moduleB = module(createdAtStart: true)
  ..single<Service>((s) => TestServiceImp());
```

The `startKoin` function will automatically create definitions instances flagged with `createAtStart`.

```dart
// Start Koin modules
startKoin((app){
    app.modules([moduleA, moduleB]);
});
```
If you need to load some definition at a special time (in a background thread instead of UI for example), just get/inject the desired components.



