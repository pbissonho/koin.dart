---
title: Koin Components
---

Sometimes you can't declare only components via Koin. Dependening on your runtime technology, you might need to retrieve instances from Koin in a class that was not created with Koin (e.g. Android)

## The KoinComponent interface

Tag your class with the `KoinComponent` interface to unlock Koin injection features:

* `inject()` - lazy inject an instance
* `get()` - retrieve an instance
* `getProperty()` - get a Koin property

We can inject the module above into class properties:

```dart
// Tag class with KoinComponent
class HelloApp extends KoinComponent{
  // lazy inject dependency
  Lazy<HelloServiceImpl> helloService;
  
  HelloApp() {
    helloService = inject<HelloServiceImpl>();
  }

  void sayHello() {
    helloService.value.sayHello();
  }
}
```

If the class already inherits another one you can use KoinComponentMixin instead of 
inheriting KoinComponent.

```dart 
// Tag class with KoinComponentMixin
class HelloApp extends App with KoinComponentMixin { 
  // lazy inject dependency
  Lazy<HelloServiceImpl> helloService;

  HelloApp() {
    helloService = inject<HelloServiceImpl>();
  }

  void sayHello() {
    helloService.value.sayHello();
  }
}
```

And we just need to start Koin and run our class:

```dart
// a module with our declared Koin dependencies 
var helloModule = module()..single((s) => HelloServiceImpl());

void main() {

    // Start Koin
    startKoin((app){
      app.module(helloModule);
    });
    
    // Run our Koin component
    HelloApp().sayHello();
}
```

#### Bootstrapping

> `KoinComponent` interface is also used to help you bootstrap an application from outside of Koin. Also, you can bring  `KoinComponent` feature by extension functions directly on some target classes (i.e: Activity, Fragment have KoinComponent feature in Android). 


## Bridge with Koin instance

The `KoinComponent` interface brings the following:

```dart
abstract class KoinComponent {

    /**
     * Get the associated Koin instance
     */
    Koin getKoin() => KoinContextHandler.get();
}
```

It opens the following possibilties:

> You can then redefine then `getKoin()` function to redirect to a local custom Koin instance



