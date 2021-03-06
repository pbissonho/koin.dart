---
title: Get Instances
---

Once you have declared some modules and you have started Koin, how can you retrieve your instances in your
Flutter widgets or Services.

## Widgets & Service as KoinComponents

The Flutter widgets are extended with the KoinComponents extension. You gain access to:

* `get()` - eager fetch instance from Koin container

For a module that declares a 'presenter' component:

```dart
final flutterModule = module()
    // a factory of CounterBloc
  ..factory((s) => CounterBloc());
```


We can just directly get an instance:

```dart
class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  CounterBloc counter;
  Lazy<CounterBloc> lazyCounter;

  @override
  void initState() {
    // Retrieve a Presenter instance
    counter = get<CounterBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```
