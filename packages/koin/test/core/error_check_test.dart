import 'package:koin/src/koin_application.dart';
import 'package:koin/src/internal/exceptions.dart';
import 'package:koin/src/module.dart';
import 'package:test/test.dart';

import '../components.dart';

void main() {
  test('description', () {
    var app = koinApplication((app) {});

    expect(() => app.koin.get<ComponentA>(),
        throwsA((value) => value is NoBeanDefFoundException));
  });

  test('unknown linked dependency', () {
    var app = koinApplication((app) {
      app.module(module()..single((s) => ComponentB(s.get())));
    });

    expect(() => app.koin.get<ComponentB>(),
        throwsA((value) => value is InstanceCreationException));
  });

  test('unknown linked dependency', () {
    var app = koinApplication((app) {
      app.module(module()..single((s) => ComponentB(s.get())));
    });

    expect(() => app.koin.get<ComponentB>(),
        throwsA((value) => value is InstanceCreationException));
  });

  test('error while creating instance', () {
    var app = koinApplication((app) {
      app.module(module()..single((s) => Boom()));
    });

    expect(() => app.koin.get<Boom>(),
        throwsA((value) => value is InstanceCreationException));
  });

  // TODO
  // Analyze a way to treat
  /*
  test('cycle error', () {
    var app = koinApplication((app) {
      app.module(module()
        ..single((s) => CycleA(s.get()))
        ..single((s) => CycleB(s.get())));
    });

    expect(() => app.koin.get<CycleA>(),
        throwsA((value) => value is StackOverflowError));
  });*/
}

class Boom {
  Boom() {
    throw 'Error';
  }
}

class CycleA {
  final CycleB cycleB;

  CycleA(this.cycleB);
}

class CycleB {
  final CycleA cycleA;

  CycleB(this.cycleA);
}
