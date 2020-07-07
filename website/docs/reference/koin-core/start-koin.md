---
title: Start Koin
---

## What is Koin.dart?

Koin is pragmatic lightweight dependency injection framework for Dart developers. Written in pure Dart, using functional resolution as key concept. Koin is a lightweight container and a pragmatic API. Koin.dart is a port of the original version written in Kotlin.

## Start the container

Koin is a DSL, a lightweight container and a pragmatic API. Once you have declared your definitions within Koin modules, your are ready to start the Koin container.

### The startKoin function

The `startKoin` function is the main entry point to launch Koin container. It need a *list of Koin modules* to run.
Modules are loaded and definitions are ready to be resolved by the Koin container.

.Starting Koin

```dart
// start a KoinApplication in Global context
startKoin((app){
    // declare used modules
    app.module(coffeeAppModule);
});
```

Once `startKoin` has been called, Koin will read all your modules & definitions. Koin is then ready for any `get()` or `by inject()` call to retrieve the needed instance.

Your Koin container can have several options:

* `logger` - to enable logging - see <<logging.adoc#_logging,logging>> section
* `properties()`, `fileProperties( )` or `environmentProperties( )` to load properties from environment, koin.properties file, extra properties ... - see <<properties.adoc#_lproperties,properties>> section


!> The `startKoin` can't be called more than once. If you need several point to load modules, use the `loadKoinModules` function.


### Behind the start - Koin instance under the hood

When we start Koin, we create a `KoinApplication` instance that represents the Koin container configuration instance. Once launched, it will produce a `Koin` instance resulting of your modules and options.
This `Koin` instance is then hold by the `GlobalContext`, to be used by any `KoinComponent` class.

The `GlobalContext` is a default JVM context strategy for Koin. It's not accessible anymore directly, as we need a component to manage different kind of context: `KoinContextHandler`

`KoinContextHandler` is responsible to register and give access to the underlying KoinContext. It's called by `startKoin` to register a new `GlobalContext`. This will allow us to register a different kind of context, in the perspective of Koin Multiplatform. `KoinContextHandler`  is then ready once `startKoin` has finished.




### Loading modules after startKoin

You can't call the `startKoin` function more than once. But you can use directly the `loadKoinModules()` functions.

This function is interesting for SDK makers who want to use Koin, because they don't need to use the `starKoin()` function and just use the `loadKoinModules` at the start of their library.

```dart
loadKoinModules([module1,module2]);
```

### Unloading modules

it's possible also to unload a bunch of definition, and then release theirs instance with the given function:

```dart
unloadKoinModules([module1,module2])
```


### Koin context isolation

For SDK Makers, you can also work with Koin in a non global way: use Koin for the DI of your library and avoid any conflict by people using your library and Koin by isolating your context.

In a standard way, we can start Koin like that:

```dart
// start a KoinApplication in Global context
startKoin((app){
    // declare used modules
    app.module(coffeeAppModule);
});
```

From this, we can use the `KoinComponent` as it: it will use the `GlobalContext` Koin instance.

But if we want to use an isolated Koin instance, you can just declare it like follow:

```dart
// create a KoinApplication
var myKoinApplication = koinApplication((app){
    app.module(coffeeAppModule);
});
```

You will have to keep your `myApp` instance avilable in your library and pass it to your custom KoinComponent implementation:

```dart
// Get a Context for your Koin instance
class MyKoinContext {
    static KoinApplication koinApp;
}
// Register the Koin context with the KoinApplication
MyKoinContext.koinApp = myKoinApplication
```

```dart
abstract class CustomKoinComponent extends KoinComponent {
     // Override default Koin instance, intially target on GlobalContext to yours
     @override
     Koin getKoin() =>  MyKoinContext.koinApp.koin;
}
```

And now, you register your context and run your own isolated Koin components:

```dart
// Register the Koin context
MyKoinContext.koinApp = myKoinApplication

class ACustomKoinComponent extends CustomKoinComponent{
    // inject & get will target MyKoinContext
}
```

### Stop Koin - closing all resources

You can close all the Koin resources and drop instances & definitions. For this you can use the `stopKoin()` function from anywhere, to stop the Koin `GlobalContext`.
Else on a `KoinApplication` instance, just call `close()`

