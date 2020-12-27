import 'package:koin/koin.dart';
import 'package:koin/src/koin_component.dart';
import 'package:test/test.dart';

class TaskViewInterface {}

class TaskView implements TaskViewInterface {}

class TaskPresenter {
  final TaskView view;

  TaskPresenter(this.view);
}

abstract class CounterInterface {
  int get value;
}

class Counter implements CounterInterface {
  @override
  final int value;

  Counter(this.value);
}

class MyAppMixin with KoinComponentMixin {
  late final TaskView tasksView;
  late final TaskPresenter taskPresenter;

  MyAppMixin() {
    tasksView = get();
    taskPresenter = get();
  }

  Lazy<TaskView> testInject() {
    return inject<TaskView>();
  }

  TaskViewInterface testBind() {
    return bind<TaskViewInterface, TaskView>();
  }
}

class CounterAppMixinWithParams with KoinComponentMixin {
  late final Counter counter;

  CounterAppMixinWithParams() {
    counter = getWithParam<Counter, int>(10);
  }

  Lazy<Counter> testInject() {
    return injectWithParam<Counter, int>(30);
  }

  CounterInterface testBind() {
    return bindWithParam<CounterInterface, Counter, int>(50);
  }
}

void main() {
  group(('without parameters'), () {
    test('can run KoinComponentMixin app', () {
      var koin = startKoin((appX) {
        appX.printLogger();
        appX.module(Module()
          ..single((s) => TaskView()).bind<TaskViewInterface>()
          ..single((s) => TaskPresenter(s.get())));
      }).koin;

      var myApp = MyAppMixin();
      expect(myApp.taskPresenter.view, myApp.tasksView);
      expect(myApp.taskPresenter, koin.get<TaskPresenter>());
      stopKoin();
    });

    test('can inject with KoinComponentMixin', () {
      var koin = startKoin((appX) {
        appX.printLogger();
        appX.module(Module()
          ..single((s) => TaskView()).bind<TaskViewInterface>()
          ..single((s) => TaskPresenter(s.get())));
      }).koin;

      var myApp = MyAppMixin();
      expect(myApp.testInject().value, koin.get<TaskView>());
      stopKoin();
    });

    test('can bind with KoinComponentMixin', () {
      var koin = startKoin((appX) {
        appX.printLogger();
        appX.module(Module()
          ..single((s) => TaskView()).bind<TaskViewInterface>()
          ..single((s) => TaskPresenter(s.get())));
      }).koin;

      var myApp = MyAppMixin();
      expect(myApp.testBind(), koin.bind<TaskViewInterface, TaskView>());
      stopKoin();
    });

    test('shoud get same koin instance', () {
      var koin = startKoin((appX) {
        appX.printLogger();
        appX.module(Module()
          ..single((s) => TaskView()).bind<TaskViewInterface>()
          ..single((s) => TaskPresenter(s.get())));
      }).koin;

      var myApp = MyAppMixin();
      expect(myApp.getKoin(), koin);
      stopKoin();
    });
  });

  group('withParams', () {
    test('can run KoinComponentMixin app - withParams', () {
      var koin = startKoin((appX) {
        appX.printLogger();
        appX.module(Module()
          ..factoryWithParam<Counter, int>((s, value) => Counter(value))
              .bind<CounterInterface>());
      }).koin;

      var myApp = CounterAppMixinWithParams();
      expect(myApp.counter.value, 10);
      expect(myApp.counter.value, koin.getWithParam<Counter, int>(10).value);
      stopKoin();
    });

    test('can inject with KoinComponentMixin', () {
      var koin = startKoin((appX) {
        appX.printLogger();
        appX.module(Module()
          ..factoryWithParam<Counter, int>((s, value) => Counter(value))
              .bind<CounterInterface>());
      }).koin;

      var myApp = CounterAppMixinWithParams();

      expect(myApp.testInject().value?.value, 30);
      expect(myApp.testInject().value?.value,
          koin.getWithParam<Counter, int>(30).value);
      stopKoin();
    });

    test('can bind with KoinComponentMixin', () {
      var koin = startKoin((appX) {
        appX.printLogger();
        appX.module(Module()
          ..factoryWithParam<Counter, int>((s, value) => Counter(value))
              .bind<CounterInterface>());
      }).koin;

      var myApp = CounterAppMixinWithParams();

      expect(myApp.testBind().value, 50);
      expect(myApp.testBind().value, koin.getWithParam<Counter, int>(50).value);
      stopKoin();
    });
  });
}
