# Koin.dart

[![Build Status](https://travis-ci.org/pbissonho/koin.dart.svg?branch=master)](https://travis-ci.org/pbissonho/koin.dart)
[![codecov](https://codecov.io/gh/pbissonho/koin.dart/branch/master/graph/badge.svg)](https://codecov.io/gh/pbissonho/koin.dart)


A pragmatic lightweight dependency injection framework. This is a port of [Koin](https://github.com/InsertKoinIO/koin) for Dart projects.

| Package                                                                            | Pub                                                                                                    |
| ---------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| [koin](https://github.com/pbissonho/koin.dart/tree/master/packages/koin)                 | [![pub package](https://img.shields.io/pub/v/koin.svg)](https://pub.dev/packages/koin)                 |
| [koin_test](https://github.com/pbissonho/koin.dart/tree/master/packages/koin_test)       | [![pub package](https://img.shields.io/pub/v/koin_test.svg)](https://pub.dev/packages/koin_test)       |
| [koin_flutter](https://github.com/pbissonho/koin.dart/tree/master/packages/koin_flutter) | [![pub package](https://img.shields.io/pub/v/koin_flutter.svg)](https://pub.dev/packages/koin_flutte) |


# Setup

## Add dependency

```yaml
dependencies:
  koin: ^[version]
```
### Flutter

```yaml
dependencies:
  koin: ^[version]
  koin_fluter: ^[version]
```

# Quick Start

## Declare a Koin module

```dart
// Given some classes 
class Controller {
  final BusinessService service;

  Controller(this.service);
}

class BusinessService {}

// just declare it
var myModule = Module()
  ..single((s) => Controller(s.get()))
  ..single((s) => BusinessService());
```

## Starting Koin

Use the startKoin() function to start Koin in your application.

In a Dart app:

```dart
void main(List<String> args) {
    startKoin((app){
      app.module(myModule);
    });
  }
```

In an Flutter app:

```dart
void main() {
  startKoin((app) {
    app.printLogger(level: Level.debug);
    app.module(homeModule);
  });
  runApp(MyApp());
}
```

## Injecting dependencies
```dart
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // Get a dependency
    var controller = get<Controller>();
    return Container(
      child: Text("${controller.toString()}"),
    );
  }
}
```


## Features

- Pragmatic
- Modules
- Scopes
- Singleton definition
- Factory definition
- Scoped definition
- Support to multiple bindings
- Support to named definition
- Easy testing
- Lazy inject
- Logging
- Support to injection parameters






