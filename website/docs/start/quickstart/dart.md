---
title: Dart
---

## Getting Started with Dart

> This tutorial lets you write a Dart application and use Koin inject and retrieve your components.

## Setup

First, check that the `koin-core` dependency is added like below:

| Package                                                                            | Pub                                                                                                    |
| ---------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| [koin](https://github.com/pbissonho/koin.dart/tree/master/packages/koin)                 | [![pub package](https://img.shields.io/pub/v/koin.svg)](https://pub.dev/packages/koin)


```yaml
dependencies:
  koin: ^[laste_version]
```


## The application

In our small app we need to have 2 components:

* HelloMessageData - hold data
* HelloService - use and display data from HelloMessageData
* HelloApplication - retrieve and use HelloService

### Data holder

Let's create a `HelloMessageData` data class to hold our data:

```dart
//
// A class to hold our message data
//
class HelloMessageData {
    final message = "Hello Koin!";
}
```

### Service

Let's create a service to display our data from `HelloMessageData`. Let's write `HelloServiceImpl` class and its interface `HelloService`:

```dart
//
// Hello Service - interface
//
abstract class HelloService {
    String hello();
}

// Hello Service Impl
// Will use HelloMessageData data
class HelloServiceImpl implements HelloService {
    final HelloMessageData helloMessageData;

    HelloServiceImpl(this.helloMessageData)

    @override
    String hello(){
        return "Hey, ${helloMessageData.message}";
    }
}
```


## The application class

To run our `HelloService` component, we need to create a runtime component. Let's write a `HelloApplication` class and tag it with `KoinComponent` interface. This will later allows us to use the `get()` functions to retrieve our component:

```dart

// HelloApplication - Application Class
// use HelloService
class HelloApplication extends KoinComponent {

    // Inject HelloService
    final helloService = get<HelloService>();

    // display our data
    static sayHello(){
        print(helloService.hello());
    }
}
```

## Declaring dependencies

Now, let's assemble `HelloMessageData` with `HelloService`, with a Koin module:

```dart
final helloModule = Module()
    ..single((s) => HelloMessageData())
    ..single<HelloService>((s) => HelloServiceImpl(s.get()))

```


We declare each component as `single`, as singleton instances.

* `single((s) => HelloMessageData())` : declare a singleton of `HelloMessageData` instance
* `single<HelloService>((s) => HelloServiceImpl(s.get()))` : Build `HelloServiceImpl` with injected instance of `HelloMessageData`, declared as singleton of `HelloService`.

## That's it!

Just start our app from a `main` function:

```dart
void main() {

startKoin((app) {
 app.printLogger(level: Level.debug);
 app.module(helloModule);
});
 
 HelloApplication().sayHello();
}
```
