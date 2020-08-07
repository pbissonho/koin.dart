# Testing

The `koin-test` project brings you small but powerful tools to test your Koin application.

## Getting your components

Just tag your test class with `KoinTest`, and you will be able to unlock `KoinComponent` & testing features:

* `inject()` - lazy inject an instance
* `get()` - retrieve an instance

Given the definitions below:

```dart
final appModule = module()..single((s) => ComponentA());
```

We can write the test below:

```dart
void main() {
   test('MyTest', () {
    startKoin((app) {
      app.module(appModule);
    });

    // Lazy inject property
    var componentA = inject<ComponentA>();

    expect(componentA, isNotNull);
  });
}
```


you can use the `setUp` `tearDown` to statr/stop  your Koin context:

```dart
setUp((){
    startKoin((app) {
      app.module(myModule);
  });
```

## Checking your modules

You can easily test module definitions.

Let's write our check test as follow:
- test modules with `testModules()` API

Let's check our modules.

```dart
void main(){
    testModules('moduleChecktest - shoud be a valid module',[myModule1,myModule2]);  
}
```

## Mocking on the fly

Once you have import `koin_test`, you can use the `declare` function to declare mocks & behavior on the fly:

```dart

class ComponentA {
  String sayHello() => 'Hello';
}

class ComponentMock extends Mock implements ComponentA {}

void main() {
  setUp(() {
    startKoin((app) {
      app.module(module()
        ..single((s) => ComponentA()));
    });
  });
  koinTearDown();

  test('declareMock with KoinTest', () {
    var componentAMock = ComponentMock();  
    when(componentAMock.sayHello()).thenReturn('Hello Mock');
    // declare a mock instance to ComponentA.
    declare<ComponentA>(componentAMock);

    // retrieve mock, same as variable above
    expect(get<ComponentA>().sayHello(), 'Hello Mock');
  });
}
```

## Starting & stopping for tests

Take attention to stop your koin instance (if you use `startKoin` in your tests) between every test. Else be sure to use `koinApplication`, for local koin instances or `stopKoin()` to stop the current global instance.

