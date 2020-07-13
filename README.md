# Koin.dart

<p align="center"><img src="https://raw.githubusercontent.com/pbissonho/koin.dart/master/logo.svg" height="150" alt="Koin.dart"></p>

<p align="center">
<a href="https://travis-ci.org/pbissonho/koin.dart"><img src="https://travis-ci.org/pbissonho/koin.dart.svg?branch=master" alt="build"></a>
<a href="https://codecov.io/gh/pbissonho/koin.dart"><img src="https://codecov.io/gh/pbissonho/koin.dart/branch/master/graph/badge.svg" alt="codecov"></a>
<a href="https://github.com/pbissonho/koin.dart"><img src="https://img.shields.io/github/stars/pbissonho/koin.dart.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Star on Github"></a>
<a href="https://github.com/tenhobi/effective_dart"><img src="https://img.shields.io/badge/style-effective_dart-40c4ff.svg" alt="style: effective dart"></a>

---

A pragmatic lightweight dependency injection framework. This is a port of [Koin](https://github.com/InsertKoinIO/koin) for Dart projects.

Written in pure Dart, using functional resolution only: no proxy, no code generation, no reflection, no Flutter context.

`Koin is a DSL, a light container and a pragmatic API`

| Package                                                                            | Pub                                                                                                    |
| ---------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| [koin](https://github.com/pbissonho/koin.dart/tree/master/packages/koin)                 | [![pub package](https://img.shields.io/pub/v/koin.svg)](https://pub.dev/packages/koin)                 |
| [koin_test](https://github.com/pbissonho/koin.dart/tree/master/packages/koin_test)       | [![pub package](https://img.shields.io/pub/v/koin_test.svg)](https://pub.dev/packages/koin_test)       |
| [koin_flutter](https://github.com/pbissonho/koin.dart/tree/master/packages/koin_flutter) | [![pub package](https://img.shields.io/pub/v/koin_flutter.svg)](https://pub.dev/packages/koin_flutte) |


## Documentation 🚒

* [Setup](http://koindart.dev/docs/setup)
* [Koin in 5 minutes](http://koindart.dev/docs/start/quickstart/dart)
* [Getting Started](http://koindart.dev/docs/start/getting-started/starting-koin)
* [Documentation References](http://koindart.dev/docs/reference/koin-core/definitions)

## Ask a Question? 🚑

- Post your question on [Stackoverflow - #koindart tag](https://stackoverflow.com/questions/tagged/koin)

## Reporting issues 💥

Found a bug on a specific feature? Open an issue on [Github issues](https://github.com/pbissonho/koin.dart/issues)

## Contribute 🛠

Want to help or share a proposal about Koin? problem on a specific feature? 

- Open an issue to explain the issue you want to solve [Open an issue](https://github.com/pbissonho/koin.dart/issues)
- After discussion to validate your ideas, you can open a PR or even a draft PR if the contribution is a big one [Current PRs](https://github.com/pbissonho/koin.dart/pulls)


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


## Maintainers

- [Pedro Bissonho](https://github.com/pbissonho)

## Credits

- [Arnaud Giuliani](https://github.com/arnaudgiuliani) and all contributors to the [original Koin](https://github.com/InsertKoinIO/koin) version written in Kotlin.

## Dependencies

- [Kt.dart](https://pub.dev/packages/kt_dart) port by [Pascal Welsch](https://github.com/passsy)
- [Equatable](https://pub.dev/packages/equatable) created by [Felix Angelov](https://github.com/felangel)
