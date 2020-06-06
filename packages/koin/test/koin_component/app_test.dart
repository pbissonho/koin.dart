import 'package:koin/koin.dart';
import 'package:test/test.dart';

class TaskViewInterface {}

class TaskView implements TaskViewInterface {}

class TaskPresenter {
  final TaskView view;

  TaskPresenter(this.view);
}

class MyAppMixin with KoinComponentMixin {
  TaskView tasksView;
  TaskPresenter taskPresenter;

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

void main() {
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

  test('can bind with KoinComponentMixin', () {
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
}
