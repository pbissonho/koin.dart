import 'package:koin/src/core/error/exceptions.dart';
import 'package:test/test.dart';

import 'package:koin/src/dsl/koin_application_dsl.dart';
import '../components.dart';

import 'package:koin/src/dsl/module_dsl.dart';

void main() {
  test('description', () {
    var app = koinApplication((app) {});

    expect(() => app.koin.get<ComponentA>(),
        throwsA((value) => value is NoBeanDefFoundException));
  });

  test('unknown linked dependency', () {
    var app = koinApplication((app) {
      app.module(module()..single((s, p) => ComponentB(s.get())));
    });

    expect(() => app.koin.get<ComponentB>(),
        throwsA((value) => value is InstanceCreationException));
  });

  test('unknown linked dependency', () {
    var app = koinApplication((app) {
      app.module(module()..single((s, p) => ComponentB(s.get())));
    });

    expect(() => app.koin.get<ComponentB>(),
        throwsA((value) => value is InstanceCreationException));
  });

  test('error while creating instance', () {
    var app = koinApplication((app) {
      app.module(module()..single((s, p) => Boom()));
    });

    expect(() => app.koin.get<Boom>(),
        throwsA((value) => value is InstanceCreationException));
  });

  // TODO
  /*
  test('cycle error', () {
    var app = koinApplication((app) {
      app.module(module()
        ..single((s, p) => CycleA(s.get()))
        ..single((s, p) => CycleB(s.get())));
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
