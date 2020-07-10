---
title: Get Instances
---

Once you have declared some modules and you have started Koin, how can you retrieve your instances in your
Flutter Widgets or Services.

## Widgets & Service as KoinComponents

Widgets, & Service are extended with the KoinComponents extension. You gain access to:

* `inject()` - lazy evaluated instance from Koin container
* `get()` - eager fetch instance from Koin container
* `release()` - release module's instances from its path

For a module that declares a 'presenter' component:

```dart
final flutterModule = module()
    // a factory of Presenter
  ..factory((s) => Presenter());
```


We can declare a property as lazy injected
or we can just directly get an instance:

```dart
class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Counter counter;
  Lazy<Counter> lazyCounter;

  @override
  void initState() {
    // Retrieve a Presenter instance
    counter = get<Counter>();
    // Lazy injected Presenter instance
    lazyCounter = inject<Counter>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

```
