---
title: Test
---

# Getting Started with Test

This tutorial lets you test a Dart application and use Koin inject and retrieve your components.

## Setup

First, add the Koin dependency like below:

| Package                                                                            | Pub                                                                                                    |
| ---------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| [koin](https://github.com/pbissonho/koin.dart/tree/master/packages/koin)                 | [![pub package](https://img.shields.io/pub/v/koin.svg)](https://pub.dev/packages/koin)                 |
| [koin_test](https://github.com/pbissonho/koin.dart/tree/master/packages/koin_test)       | [![pub package](https://img.shields.io/pub/v/koin_test.svg)](https://pub.dev/packages/koin_test)


```yaml
dependencies:
  koin: ^[laste_version]

dev_dependencies:
  koin_test: ^[laste_version]
```

## Declared dependencies

We reuse the koin dart getting started example, to use the koin module:

```dart
final helloModule = Module()
    ..single((s) => HelloMessageData())
    ..single<HelloService>((s) => HelloServiceImpl(s.get()))
```

## Writing our first Test

To make our first test, let's write a simple unit test file and import `koin_test.dart`. We will be able then, to use `by inject()` operators.

```dart
void main() {
  setUp(() {
    startKoin((app) {
      app.module(helloModule);
    });
  });

  tearDown(() {
    stopKoin();
  });

  var model = get<HelloMessageData>();
  var service = get<HelloService>();

  test('unit test', () {
    var helloApp = HelloApplication();
    helloApp.sayHello();

    expect(service, helloApp.helloService);
    expect("Hey, ${model.message}", service.hello());
  });
}
```

## Mocking

You can use the `declare` function to declare mocks:

```dart

HelloMessageDataMock implements HelloMessageData {}

void main() {
  setUp(() {
    startKoin((app) {
      app.module(helloModule);
    });
  });

  tearDown((){
    stopKoin();
  });

  test('should inject my components', () {

    var dataMock = HelloMessageDataMock();  
    // declare a mock instance to HelloMessageData.
    declare<HelloMessageData>(dataMock);

    // retrieve mock, same as variable above
    expect(get<HelloMessageData>(), isA<HelloMessageDataMock>());

    // then HelloService will be using the mocked instance.
    expect(get<HelloService>().helloMessageData, isA<HelloMessageDataMock>());    
  });
}
```

## Verifying modules

Let's write our check test as follow:
- test modules with `testModule()` function

```dart
void main(){
    testModule('moduleChecktest - shoud be a valid module',helloModule);  
}
```