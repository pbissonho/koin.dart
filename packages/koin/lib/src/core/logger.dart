/*
 * Copyright 2017-2018 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * */

//
// Koin Loggers
//
// @author - Arnaud GIULIANI
//
// Ported to Dart from Kotlin by:
// @author - Pedro Bissonho
//

const koinTage = '[Koin]';

enum Level { info, error, debug, none }

Logger logger = Logger.logger;

abstract class Logger {
  final Level level;

  const Logger([this.level = Level.info]);

  static Logger logger = PrintLogger(Level.debug);

  void log(Level level, String msg);

  void isAtLog(Level level, String msg, Level isAtLevel) {
    if (isAt(isAtLevel)) {
      log(level, msg);
    }
  }

  void debug(String msg, {Level level}) {
    log(Level.debug, msg);
  }

  void isAtdebug(String msg, Level isAtLevel) {
    isAtLog(Level.debug, msg, isAtLevel);
  }

  void isAtInfo(String msg, Level isAtLevel) {
    isAtLog(Level.info, msg, isAtLevel);
  }

  void info(String msg) {
    log(Level.info, msg);
  }

  void error(String msg) {
    log(Level.error, msg);
  }

  bool isAt(Level level) => this.level == level;
}

class EmptyLogger extends Logger {
  const EmptyLogger(Level loglevel);

  @override
  bool isAtLog(Level level, String msg, Level isAtLevel) => false;

  @override
  void log(Level level, String message) {}
}

class PrintLogger extends Logger {
  const PrintLogger(Level level) : super(level);

  @override
  void log(Level level, String msg) {
    print('[${parse(level)}] $koinTage $msg');
  }

  String parse(Object enumItem) {
    if (enumItem == null) return 'LogLevel';
    return enumItem.toString().split('.')[1];
  }
}
