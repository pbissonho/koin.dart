---
title: Modules
---

By using Koin, you describe definitions in modules. In this section we will see how to declare, organize & link your modules.

## What is a module?

A Koin module is a "space" to gather Koin definition. It's declared with the `module` function.

```dart
final myModule = module()  // Your definitions ...
```

## Using several modules

Components doesn't have to be necessarily in the same module. A module is a logical space to help you organize your definitions, and can depend on definitions from other
module. Definitions are lazy, and then are resolved only when a a component is requesting it.

Let's take an example, with linked components in separate modules:

```dart
// ComponentB <- ComponentA
class ComponentA {}

class ComponentB {
  final ComponentA componentA;

  ComponentB(this.componentA);
}

final myModuleA = module()
   // Singleton ComponentA
  ..single((s) => ComponentA());

final myModuleB = module()
  // Singleton ComponentB with linked instance ComponentA
  ..single((s) => ComponentB(s.get()));
```
:::important
Koin definitions are lazy: a Koin definition is started with Koin container but is not instantiated. An instance is created only a request for its type has been done.
:::
We just have to declare list of used modules when we start our Koin container:

```dart
// Start Koin with moduleA & moduleB
startKoin((app){
    app.modules([myModuleA,myModuleB]);
});
```

Koin will then resolve dependencies from all given modules.

## Linking modules strategies

As definitions between modules are lazy, we can use modules to implement different strategy implementation: declare an implementation per module.

Let's take an example, of a Repository and Datasource. A repository need a Datasource, and a Datasource can be implemented in 2 ways: Local or Remote.

```dart
class Repository {
  final Datasource datasource;

  Repository(this.datasource);
}

abstract class Datasource {}

class LocalDatasource implements Datasource {}

class RemoteDatasource implements Datasource {}
```

We can declare those components in 3 modules: Repository and one per Datasource implementation:

```dart
final repositoryModule = module()
  ..single((s) => Repository(s.get()));

final localDatasourceModule = module()
  ..single<Datasource>((s) => LocalDatasource());

final remoteDatasourceModule = module()
  ..single<Datasource>((s) => LocalDatasource());
```

Then we just need to launch Koin with the right combination of modules:

```dart
// Load Repository + Local Datasource definitions
startKoin((app) {
    app.modules([repositoryModule, localDatasourceModule]);
});
// Load Repository + Remote Datasource definitions
startKoin((app) {
    app.modules([repositoryModule, remoteDatasourceModule]);
});
```

## Overriding definition or module

Koin won't allow you to redefinition an already existing definition (type,name,path ...). You will an an error if you try this:

```dart
final myModuleA = module()
  ..single<Service>((s) => ServiceImp());

final myModuleB = module()
  ..single<Service>((s) => TestServiceImp());

// Will throw an BeanOverrideException
startKoin((app) {
    app.modules([myModuleA, myModuleB]);
});
```

To allow definition overriding, you have to use the `override` parameter:

```dart
final myModuleA = module()
  ..single<Service>((s) => ServiceImp());

final myModuleB = module()
   // override for this definition
  ..single<Service>((s) => TestServiceImp(), override: true);
```

```dart
final myModuleA = module()
  ..single<Service>((s) => ServiceImp());

// Allow override for all definitions from module
final myModuleB = module(override: true)
  ..single<Service>((s) => TestServiceImp());
```
:::important
Order matters when listing modules and overriding definitions. You must have your overriding definitions in last of your module list.
:::info
