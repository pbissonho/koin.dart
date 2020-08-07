# Logging

Koin has a simple logging API to log any Koin activity (allocation, lookup ...)

Koin proposes some implementation of logging, in function of the target platform:

* `PrintLogger` - directly log into console (included in `koin-core`)
* `EmptyLogger` - log nothing (included in `koin-core`)

## Set logging at start

By default, By default Koin use the `EmptyLogger`. You can use directly the `PrintLogger` as following:

```dart
startKoin((app){
    app.printLogger(level: Level.info);
  });
```


