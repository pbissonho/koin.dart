---
title: Testing
---

## Making your test a KoinComponent with KoinTest

By import  `koin_test.dart`, you will be able to use all available test methods:

* `inject()` & `get()` - function to retrieve yoru instances from Koin
* `testModules()`,`testModule()` & `testKoinDeclaration()`  - help you check your configuration. These are functions marked as isTest, that is, they are equivalent to test();
* `declareModule()` - to declare a  module to be loaded in the global context of koin
* `declare()` - to a instance to be loaded in the global context of koin

* `koinTearDown()` - Register a tearDown function that close Koin afters tests, will be called after each test is run.
* `koinSetUp()` - Register a setUp function that starts koin before tests, will be called after each test is run.
* `koinTest()` - Configures the testing environment to automatically start and close Koin for each test.


```dart
class ComponentA {}
class ComponentB {
    final ComponentA a;
    ComponentB(this.a);
}

void main() {
   test('should inject my components', () {
    startKoin((app) {
      app.module(module()
        ..single((s) => ComponentA())
        ..single((s) => ComponentB(s.get())));
    });

    // Lazy inject property
    var componentA = inject<ComponentA>();
    // directly request an instance
    var componentB = get<ComponentB>();

    expect(componentA, isNotNull);
    expect(componentB.a, componentA);
  });
}
```

:::tip TIP
Don't hesitate to overload Koin modules configuration to help you partly build your app.
:::

## Test SetUp

### Create a Koin context for your test

You can easily create and hold a Koin context for each of your test with the following setup:

```dart
setUp((){
    startKoin((app) {
      app.module(myModule);
  });
```

!> koin-test project is not tied to mockito

## Mocking out of the box

Instead of making a new module each time you need a mock, you can declare a mock on the fly with `declare`:

```dart
class ComponentA {}
class ComponentB {
    final ComponentA a;
    ComponentB(this.a);
}

class ComponentAMock implements ComponentA {}

void main() {
  setUp(() {
    startKoin((app) {
      app.module(Module()
        ..single((s) => ComponentA())
        ..single((s) => ComponentB(s.get())));
    });
  });

  tearDown((){
    stopKoin();
  });


  test('should inject my components', () {

    var componentAMock = ComponentAMock();  
    // declare a mock instance to ComponentA.
    declare<ComponentA>(componentAMock);

    // retrieve mock, same as variable above
    expect(get<ComponentA>(), isNotNull);

    // retrieve mock, same as variable above
    expect(get<ComponentA>(), isA<ComponentAMock>());

    // is built with mocked ComponentA
    expect(get<ComponentB>(), isNotNull);

    // shoud get the same instance declared above
    expect(get<ComponentA>(), componentAMock);
  });
}

## Checking your Koin modules

Koin offers a way to test if you Koin modules are good: `testModules` - walk through your definition tree and check if each definition is bound

```dart
void main(){
    testModules('moduleChecktest - shoud be a valid module',[myModule1,myModule2]);  
}
```

## Starting & stopping Koin for your tests

Take attention to stop your koin instance (if you use `startKoin` in your tests) between every test. Else be sure to use `koinApplication`, for local koin instances or `stopKoin()` to stop the current global instance.


