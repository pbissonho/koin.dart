
Koin has a simple logging API to log any Koin activity (allocation, lookup ...). The logging API is represented by the class below:

Koin Logger

```dart
abstract class Logger {
  final Level level;

  const Logger([this.level = Level.info]);

  static Logger logger = PrintLogger(Level.debug);

  void log(Level level, String msg);

  bool canLog(Level level) {
    return this.level == level;
  }

  void doLog(Level level, String msg) {
    if (canLog(level)) {
      log(level, msg);
    }
  }

  void debug(String msg) {
    log(Level.debug, msg);
  }

  void info(String msg) {
    log(Level.info, msg);
  }

  void error(String msg) {
    log(Level.error, msg);
  }

  bool isAt(Level level) => this.level == level;
}
```

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


