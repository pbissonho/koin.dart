---
title: Injection Parameter
---

In any definition, you can use injection parameter: parameter that will be injected and used by your definition:

## Defining an injection parameter

Below is an example of injection parameter. We established that we need a `id` parameter to build of `MyClass` class:

```dart
class MyClass {
  final int id;

  Bloc(this.id);
}

final myModule = Module()
  ..singleWithParam<MyClass, int>((s, id) => MyClass(id));
```


## Injecting with values

In contrary to resolved dependencies (resolved with with `get()` or `inject`), injection parameter are passed through the resolution API with parameter.

For that it will be necessary to use `geWithParam()` or `injectWithParam()`.

```dart
class MyApp with KoinComponentMixin {
  MyClass myClass;
  MyComponent() {
    myClass = getWithParam<MyClass>(10);
  }
}
```

## Multiple parameters

If we want to have multiple parameters in our definition, we can insert the parameters as properties of a class.

```dart
class MyClass {
  final int param1;
  final String param2;

  MyClass(this.param1, this.param2);

  void doDomething() {
    print("$param1 $param2");
  }
}

class MyClassParam {
  final int param1;
  final String param2;

  MyClassParam(this.param1, this.param2);
}

final koinModule = Module()
  ..singleWithParam<MyClass, MyClassParam>(
      (s, p) => MyClass(p.param1, p.param2));

class App with KoinComponentMixin {
  App() {
    final myClass =
        getWithParam<MyClass, MyClassParam>(MyClassParam(10, "Hello"));
  }
}   
```

