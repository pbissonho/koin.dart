---
title: Modules Definitions
---

Writing definitions in Koin is done via Dart functions, that describe ishow is built your instance. Once you have configured your Koin application, let's write some modules and definitions.

## Module & definitions

Given some classes that we need to inject:

```dart
class HttpClient {
  final String url;

  HttpClient(this.url);
}

class DataRepository {
    final HttpClient httpClient;

  DataRepository(this.httpClient);
}
class Bloc {
  final DataRepository dataRepository;

  Bloc(this.dataRepository);
}
```

Here how we could define some components:


```dart
final myModule = Module()
  // Define a singleton for type HttpClient
  ..single<HttpClient>(((s) => HttpClient('server_url')))
  // Define a singleton for type  DataRepository
  // Resolve the HttpClient dependency with s.get()
  ..single<DataRepository>(((s) => DataRepository(s.get())))
  // Define a factory (create a new instance each time) for type Bloc (infered parameter in <>)
  // Resolve the DataRepository dependency with s.get()
  ..factory<Bloc>(((s) => Bloc(s.get())));
```

## Qualifiers

You can give a qualifier to a component. This qualifier can be a string or a type, and is setup with the `named()` function:

```dart
final myModule = Module()
    // Define a single Bloc named 'single'
  ..single<Bloc>(((s) => Bloc(s.get())), qualifier: named('single'))
   // Define a factory for type Bloc
  ..factory<Bloc>(((s) => Bloc(s.get())));
}
```



> This qualifier can be associated to a class or directly to a type:


```dart
class MyClass {

}
// Type qualifier
..single<DataRepository>(((s) => DataRepository(s.get())), qualifier: named<MyClass>())

// String qualifier
..single<DataRepository>(((s) => DataRepository(s.get())), qualifier: named('single'))
```

## Additional types

In the module API, for a definition, you can give some extra type to bind, with the `bind` operator (`binds` for list of Class):

```dart

class Component1Interface {}

class Component1 implements Component1Interface {}

final myModule = Module()
  ..single<Component1>(((s) => Component1())).bind<Component1Interface>();
```

Then you can request your instance with `get<Component1>()` or `get<ComponentInterface1>()`.

You can bind multiple definitions with the same type:

```dart
final myModule = Module()
  ..single<Component1>(((s) => Component1())).bind<Component1Interface>()
  ..single<Component2>(((s) => Component2())).bind<Component1Interface>();
```

But here you won't be able to request an instance with `get<ComponentInterface1>()`. You will have to use `koin.bind<Component1,ComponentInterface1>()` to retrieve an instance of `ComponentInterface1`, with the `Component1` implementation.

Note that you cal also look for all components binding a given type: `getAll<ComponentInterface1>()` will request all instances binding `ComponentInterface1` type.


## Combining several modules

There is no concept of import in Koin. Just combine several complementary modules definitions.

Let's dispatch definitions in 2 modules:

```dart
final myModule1 = Module()
  ..single<HttpClient>(((s) => HttpClient('server_url')))
  ..single<DataRepository>(((s) => DataRepository(s.get())));

final myModule2 = Module()..factory<Bloc>(((s) => Bloc(s.get())));
```

We just need to list them for Koin:

```dart
startKoin((app){
    app.modules([myModule1, myModule2]);
  });
```

## Loading after start

After Koin has been started with `startKoin { }` function, it is possible to load extra definitions modules with the following function: `loadKoinModules(modules...)`

## Dropping definitions

Once a modules has been loaded into Koin, we can unload it and then drop definitions and instances, related to those definitions. for this we use the `unloadKoinModules(modules...)`

```dart
void main() {
  var koin = startKoin((app) {
    app.modules([myModule]);
  }).koin;

  koin.getWithParam<MySingle>(45); // -> id is 45
  unloadKoinModule(myModule);
  loadKoinModule(myModule);

  koin.getWithParam<MySingle>(40); // -> id is 40
}
```

## Declare on the fly

Allows you to declare an instance on the fly with Koin already initialized or in a scope already created.

```dart
void main() {
  // no def
  var koin = startKoin((app) {}).koin;

  // Create an instance
  var component = Component1();

  // declare it
  koin.declare(component);

  // retrieve it
  expect(component, koin.get<Component1>());
}
```


You can also use a qualifier or secondary types to help create your definition:

```dart
koin.declare(component, qualifier: named('qualifier'), secondaryTypes: []);
```

## Recap

A quick recap of the Koin keywords:

* `module()` - create a Koin Module or a submodule (inside a module)
* `factory()` - provide a factory bean definition
* `single()` - provide a single bean definition
* `get()` - resolve a component dependency
* `named()` - define a qualifier with type, enum or string
* `bind()` - additional Dart type binding for given bean definition
* `binds()` - list of additional Dart types binding for given bean definition

