
# Getting Started with Test

> This tutorial lets you test a Dart application and use Koin inject and retrieve your components.

## Setup

First, add the Koin dependency like below:

```yaml
dependencies:
  koin: ^[laste_version]

dev_dependencies:
  koin_test: ^[laste_version]
```

## Declared dependencies

We reuse the `koin-core` getting-started project, to use the koin module:

```dart
var helloModule = Module()
    ..single((s) => HelloMessageData())
    ..single<HelloService>((s) => HelloServiceImpl(s.get()))
```

## Writing our first Test

To make our first test, let's write a simple Junit test file and import `koin_test.dart`. We will be able then, to use `by inject()` operators.

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

You can even make Mocks directly into MyPresenter, or test MyRepository. Those components doesn't have any link with Koin API.


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
- test modules with `testModule()` API

```dart
void main(){
    // 
    testModule('moduleChecktest - shoud be a valid module',helloModule);  
}
```