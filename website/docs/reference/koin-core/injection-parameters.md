---
title: Injection parameters
---

In any definition, you can use injection parameters: parameters that will be injected and used by your definition:

## Defining an injection parameter

Below is an example of injection parameters. We established that we need a `view` parameter to build of `Presenter` class:

```dart
class View {}

class Presenter {
  final View view;

  Presenter(this.view);
}

var myModule = module(createdAtStart: true)
  ..single1<Presenter, View>((s, view) => Presenter(view));
```


## Injecting with values

In contrary to resolved dependencies (resolved with with `get()`), injection parameters are *parameters passed through the resolution API*.
This means that those parameters are values passed with `get()` and `by inject()`, with the `parametersOf()` function:

```dart
class MyComponent extends View with KoinComponentMixin {
  Presenter presenter;
  MyComponent() {
    presenter = getP<Presenter>(parameters: parametersOf([this]));
  }
}
```

## Multiple parameters

If we want to have multiple parameters in our definition, we can use the *destructured declaration* to list our parameters:

```dart
class Presenter {
  final View view;
  final int id;

  Presenter(this.view, this.id);
}

var myModule = module()
  ..single2<Presenter, View, int>((s, view, id) => Presenter(view, id));
```

In a `KoinComponent`, just use the `parametersOf` function with your arguments like below:

```dart
class MyComponent extends View with KoinComponentMixin {
  Presenter presenter;
  MyComponent() {
    presenter = getP<Presenter>(parameters: parametersOf([this, 10]));
  }
}
```

