# Koin.dart

<p align="center"><img src="https://raw.githubusercontent.com/pbissonho/koin.dart/master/logo.svg" height="150" alt="Koin.dart"></p>

<p align="center">
<a href="https://travis-ci.org/pbissonho/koin.dart"><img src="https://travis-ci.org/pbissonho/koin.dart.svg?branch=master" alt="build"></a>
<a href="https://codecov.io/gh/pbissonho/koin.dart"><img src="https://codecov.io/gh/pbissonho/koin.dart/branch/master/graph/badge.svg" alt="codecov"></a>
<a href="https://github.com/pbissonho/koin.dart"><img src="https://img.shields.io/github/stars/pbissonho/koin.dart.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Star on Github"></a>
<a href="https://github.com/tenhobi/effective_dart"><img src="https://img.shields.io/badge/style-effective_dart-40c4ff.svg" alt="style: effective dart"></a>

---

An pragmatic and flexible lightweight dependency injection library. This is a port of [Koin](https://github.com/InsertKoinIO/koin) for Dart projects.

Written in pure Dart, using functional resolution only: no code generation, no reflection.


| Package                                                                            | Pub                                                                                                    |
| ---------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| [koin](https://github.com/pbissonho/koin.dart/tree/master/packages/koin)                 | [![pub package](https://img.shields.io/pub/v/koin.svg)](https://pub.dev/packages/koin)                 |
| [koin_test](https://github.com/pbissonho/koin.dart/tree/master/packages/koin_test)       | [![pub package](https://img.shields.io/pub/v/koin_test.svg)](https://pub.dev/packages/koin_test)       |
| [koin_flutter](https://github.com/pbissonho/koin.dart/tree/master/packages/koin_flutter) | [![pub package](https://img.shields.io/pub/v/koin_flutter.svg)](https://pub.dev/packages/koin_flutter) |
| [koin_bloc](https://github.com/pbissonho/koin.dart/tree/master/packages/koin_bloc) | [![pub package](https://img.shields.io/pub/v/koin_bloc.svg)](https://pub.dev/packages/koin_bloc) |
| [koin_devtools](https://github.com/pbissonho/koin.dart/tree/master/packages/koin_devtools) | [![pub package](https://img.shields.io/pub/v/koin_devtools.svg)](https://pub.dev/packages/koin_devtools) |


## Why should I use Koin?

- Allows to dispose your objects at the moment that you are no longer using them.

- It does not depend on the Flutter.
  * The core does not depend on Flutter, so it is possible to use it with any Dart application.

- Define in which scope a variable can be accessed.
  * The koin scope allows you to define in which part of the widget tree a variable will be accessible

- Integration by default for [Bloc library](https://pub.dev/packages/bloc), but it can be easily used with any state management.

- Koin DevTools to inspect the state of your objects.
  * Inspect the internal state of each object at any time on a Flutter page.

- Dependencies are instances only when needed.
  * Its class is instant when used for the first time.
  * Koin has a implementation of [Lazy](https://www.lordcodes.com/articles/the-power-of-lazy-properties-in-kotlin) by Kotlin to enhance this functionality.

- It is not invasive. 
  * Insert Koin in your project without changing the structure of your widgets.

- Facilitates dependency injection by constructor  
  *  Using dependency injection by constructor you decrease the coupling and make the test easier.
  *  Makes it easy to know the dependencies of your components. Just look at your class's constructor to identify how dependencies it uses.

## Features

- Modules
- Scopes
- Singleton provider(definition)
- Factory provider(definition)
- Scoped provider(definition)
- Support to multiple bindings
- Support to named provider(definition)
- Easy testing
- Lazy inject
- Logging
- Support to parameter injection 
- Integration by default for Bloc library
- DevTools for state inspection


## What Koin.dart is not?

It is not a state manager. Koin does not have any type of state management, use koin with any state manager.


## Table Of Contents

* [Quick Start](#Quick-Start)
* [Setup](#setup)
* [Getting Started](https://pbissonho.github.io/docs/start/getting-started/starting-koin)
* [Documentation References](https://pbissonho.github.io/docs/reference/koin-core/definitions)
* [Examples](#Examples)


 
## Roadmap

* Improve documentation
* Add more examples
  * Example of use with Redux, Mobx and RxDart.
  * Example with HTTP server frameworks.
* Create an external DevTools 
* Add logger plugin for [logger](https://pub.dev/packages/logger)



## Quick Start

### Basic Setup

### Dart 

```yaml
dependencies:
  koin: ^[version]
```
### Flutter

```yaml
dependencies:
  koin: ^[version]
  koin_flutter: ^[version]
```


### Declare a Koin module

```dart
// Given some classes 
class Bloc {
  final Repository service;

  Bloc(this.service);

  get state => "Hello";
}

class Repository {}

// just declare your providers(definitions)
final myModule = Module()
  // Declare a single provider(definition) for Bloc class
  ..single((s) => Bloc(s.get()))
  // Declare a single provider(definition) for Repository class
  ..single((s) => Repository());
```

### Starting Koin

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
    app.module(homeModule);
  });
  runApp(MyApp());
}
```

### Injecting dependencies
```dart
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // Get a dependency
    final bloc = get<Bloc>();
    return Container(
      child: Text("${bloc.state()}"),
    );
  }
}
```

## Setup 

### Dart

```yaml
dependencies:
koin: ^[version]
# Koin for Unit tests
dev_dependencies:
koin_test: ^[version]
```

### Flutter

```yaml
dependencies:
  koin: ^[version]
  koin_flutter: ^[version]

# Koin for Unit tests
dev_dependencies:
  koin_test: ^[version]
```

### Flutter + Bloc

```yaml
dependencies:
  koin: ^[version]
  koin_flutter: ^[version]
  koin_bloc: ^[version]

# Koin for Unit tests
dev_dependencies:
  koin_test: ^[version]
```

## Examples

### Basic

An simple example in Flutter.
Code: [Repository](https://github.com/pbissonho/koin.dart/tree/master/examples/basic)

### Counter

A more elaborate example using Bloc library as a state management.
Code: [Repository](https://github.com/pbissonho/koin.dart/tree/master/examples/counter)

### Real World

A application to demonstrate the Koin in a real world application.

#### Features
 - Log in
 - Sign up
 - Loggout
 - Password reset

Code: [Repository](https://github.com/pbissonho/Flutter-Authentication)


## DevTools 

Koin DevTools allows you to inspect the internal state of the objects created by the providers(definitions).

### Usage

Just insert the KoinDevTools Widget somewhere in your application or use showDevTools.

```dart
class Page extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     /// Just insert the KoinDevTools
      endDrawer: KoinDevTools(),
      body: IconButton(icon: Text('Shod DevTools'), onPressed: () {
        // Or use this
        showDevTools(context);
      },),
    );
  }
}
```

## Ask a Question?

- Post your question on [Stackoverflow - #koindart tag](https://stackoverflow.com/questions/tagged/koin)

## Reporting issues

Found a bug on a specific feature? Open an issue on [Github issues](https://github.com/pbissonho/koin.dart/issues)

## Contribute

Want to help or share a proposal about Koin? problem on a specific feature? 

- Open an issue to explain the issue you want to solve [Open an issue](https://github.com/pbissonho/koin.dart/issues)
- After discussion to validate your ideas, you can open a PR or even a draft PR if the contribution is a big one [Current PRs](https://github.com/pbissonho/koin.dart/pulls)

## Maintainers	

- [Pedro Bissonho](https://github.com/pbissonho)

## Credits

- [Arnaud Giuliani](https://github.com/arnaudgiuliani) and all contributors to the [original Koin](https://github.com/InsertKoinIO/koin) version written in Kotlin.

## Dependencies

- [Kt.dart](https://pub.dev/packages/kt_dart) port by [Pascal Welsch](https://github.com/passsy)
