import 'package:koin/koin.dart';
import 'package:test/test.dart';
import '../components.dart';
import '../extensions/koin_application_ext.dart';

void main() {
  test('create an empty module', () {
    final app = koinApplication((app) {
      app.printLogger();
      app.modules([module()]);
    });

    app.expectDefinitionsCount(0);
  });
  test('load a module once started', () {
    final app = koinApplication((app) {});
    app.expectDefinitionsCount(0);

    app.modules([module()..single((s) => Simple())]);
    app.expectDefinitionsCount(1);
  });

  test('create a module with single', () {
    final app = koinApplication((app) {
      app.modules([module()..single((s) => Simple())]);
    });

    app.expectDefinitionsCount(1);
  });

  test('create a complex single DI module', () {
    final app = koinApplication((app) {
      app.modules([
        module()..single((s) => Simple())..single((s) => ComponentB(s.get()))
      ]);
    });

    app.expectDefinitionsCount(2);
  });

  test('create a complex factory DI module', () {
    final app = koinApplication((app) {
      app.modules([
        module()
          ..single((s) => Simple())
          ..single((s) => ComponentB(s.get()))
          ..factory((s) => ComponentC(s.get()))
      ]);
    });

    app.expectDefinitionsCount(3);
  });

  test('create modules list', () {
    final app = koinApplication((app) {
      app.modules([
        module()..single((s) => Simple()),
        module()..single((s) => ComponentB(s.get()))
      ]);
    });

    app.expectDefinitionsCount(2);
  });

  test('create modules list timing', () {
    koinApplication((app) {
      app.modules([
        module()..single((s) => Simple()),
        module()..single((s) => ComponentB(s.get()))
      ]);
    });
    koinApplication((app) {
      app.modules([
        module()..single((s) => Simple()),
        module()..single((s) => ComponentB(s.get()))
      ]);
    });
  });

  test('can add modules for list', () {
    var modA = module()..single((s) => ComponentA());
    var modB = module()..single((s) => ComponentB(s.get()));

    var mods = modA + modB;
    expect(mods, [modA, modB]);
  });

  test('can add modules to list', () {
    var modA = module()..single((s) => ComponentA());
    var modB = module()..single((s) => ComponentB(s.get()));
    var modC = module()..single((s) => ComponentC(s.get()));

    var mods = modA + modB + [modC];
    expect(mods, [modA, modB, modC]);
  });

  test('can add modules to list', () {
    var modA = module()..single((s) => ComponentA());
    var modB = module()..single((s) => ComponentB(s.get()));
    var modC = module()..single((s) => ComponentC(s.get()));

    var mods = modA + modB + [modC];
    expect(mods, [modA, modB, modC]);
  });
}
