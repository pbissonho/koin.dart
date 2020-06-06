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
  Koin koin;

  tearDown(() {
    stopKoin();
  });

  setUp(() {
    koin = startKoin((appX) {
      appX.printLogger();
      appX.module(Module()
        ..single((s) => TaskView()).bind<TaskViewInterface>()
        ..single((s) => TaskPresenter(s.get())));
    }).koin;
  });

  test('can run KoinComponentMixin app', () {
    var myApp = MyAppMixin();

    expect(myApp.taskPresenter.view, myApp.tasksView);
    expect(myApp.taskPresenter, koin.get<TaskPresenter>());
  });

  test('can inject with KoinComponentMixin', () {
    var myApp = MyAppMixin();

    expect(myApp.testInject().value, koin.get<TaskView>());
  });

  test('can bind with KoinComponentMixin', () {
    var myApp = MyAppMixin();

    expect(myApp.testBind(), koin.bind<TaskViewInterface, TaskView>());
  });

  test('can bind with KoinComponentMixin', () {
    var myApp = MyAppMixin();
    expect(myApp.getKoin(), koin);
  });
}
