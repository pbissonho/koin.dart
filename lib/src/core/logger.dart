/*
 * Copyright 2017-2018 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * */

/*
 * Koin Logger
 *
 * @author - Arnaud GIULIANI
 * 
 * Ported to Dart from Kotlin by:
 * @author - Pedro Bissonho 
 */

const koinTage = "[Koin]";

enum Level { info, error, debug }

abstract class Logger {
  final Level level;

  const Logger([this.level = Level.info]);

  void log(Level level, String msg);

  void info(String msg) {
    log(Level.info, msg);
  }

  void error(String msg) {
    log(Level.error, msg);
  }

  void debug(String msg) {
    log(Level.debug, msg);
  }

  bool isAt(Level level) => this.level == level;
}

class EmptyLogger extends Logger {
  EmptyLogger(Level loglevel);

  @override
  void log(Level level, String message) {}
}

class PrintLogger extends Logger {
  PrintLogger(Level level) : super(level);

  @override
  void log(Level level, String msg) {
    print("[$level] $koinTage $msg");
  }
}
