---
title: Start Koin
---

> Koin is a container & a pragamtic API to leverage your dependencies. 

The Koin consists in:

* KoinApplication: describe how to configure your Koin application
* Module: describe your definitions

Starting Koin consists in using the `startKoin` fuction as below:

## StartKoin

In a classical Dart file:

```dart
void main(){
 startKoin((app){
    // enable Printlogger with default Level.INFO
    // can have Level & implementation
    // equivalent to logger(Level.INFO, PrintLogger())
    app.printLogger();
    // list all used modules
    app.module(coffeeAppModule);
 });
}
```

## Starting for Flutter

In any Flutter class:

```dart
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    startKoin((app) {
      app.printLogger(level: Level.debug);
      app.modules(myAppModules)
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage());
  }
}
```

## Custom Koin instance 

Here below are the KoinApplication builders:

* `startKoin()` - Create and register following KoinApplication instance
* `koinApplication()` - create KoinApplication instance

```dart
// Create and register following KoinApplication instance
startKoin((app){
    app.printLogger();
    app.module(coffeeAppModule);
 });

// create KoinApplication instance
koinApplication((app){
    app.module(coffeeAppModule);
 });
```

## Logging

At start, Koin log what definition is bound by name or type (if log is activated):

```
[INFO] [Koin] bind type:'CoffeeMaker' ~ [type:Single,class:'CoffeeMaker']
[INFO] [Koin] bind type:'Pump' ~ [type:Single,class:'Pump']
[INFO] [Koin] bind type:'Heater' ~ [type:Single,class:'Heater']
```

## DSL

A quick recap of the Koin keywords:

* `startKoin()` - Create and register following KoinApplication instance
* `koinApplication()` - create KoinApplication instance
* `modules(...)` - declare used modules
* `logger()` - declare PrintLogger
