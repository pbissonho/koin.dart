import 'package:koin/koin.dart';
import 'package:koin/src/core/context/context_functions.dart';
import 'package:koin/src/core/instance/instance_context.dart';
import 'package:test/test.dart';

import '../classes.dart';
import '../test_extension/koin_application_ext.dart';

void main() {
  test("is declared as created at start", () {
    var app = KoinApplication().module(module()
      ..single<ComponentA>((s, p) => ComponentA(), createdAtStart: true));

    var defA = app.getDefinition(ComponentA);
    expect(true, defA.options.isCreatedAtStart);
   // expect(false, defA.scopeDefinition);
  });

  test("is created at start", () {
    var app = startKoin((app, context) {
      app.module((module()
        ..single<ComponentA>((s, p) => ComponentA(), createdAtStart: true)));
    });

    var defA = app.getDefinition(ComponentA);
    expect(true, defA.options.isCreatedAtStart);
    expect(true, defA.getInstance().isCreated(InstanceContext()));

    // TODO
    // definitions are not booting at the beginning.

    stopKoin();
  }, skip: true);

  test("factory is not created at start", () {
    var app = KoinApplication()
        .module(module()..factory<ComponentA>((s, p) => ComponentA()));

    var defA = app.getDefinition(ComponentA);
    expect(false, defA.options.isCreatedAtStart);
    expect(false, defA.getInstance().isCreated(InstanceContext()));
    app.close();
  });
}
