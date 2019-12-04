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
 */

/*
 * Measure functions
 *
 * @author - Arnaud GIULIANI
 * 
 * Ported to Dart from Kotlin by:
 * @author - Pedro Bissonho 
 */

class Measure {
  ///
  /// Measure code execution
  ///
  static double measureDurationOnly(void function()) {
    var start = Stopwatch()..start();
    function();
    var resultInt = start.elapsed.inMilliseconds;
    var result = start.elapsed.inMilliseconds.toDouble();
    return result;
  }

  ///
  /// Measure code execution and get result
  ///
  static Pair measureDuration(Object function()) {
    var start = Stopwatch()..start();
    Object result = function();
    var duration = start.elapsed.inMilliseconds.toDouble();
    return Pair(duration, result);
  }

  ///
  /// Measure code execution and get result
  ///

  static Pair measureMicroseconds(function()) {
    var start = Stopwatch()..start();
    var resultF = function();
    var result = start.elapsedMicroseconds.toDouble();
    return Pair(result, resultF);
  }
}

class Pair<T> {
  final double duration;
  final T result;

  Pair(this.duration, this.result);

  @override
  String toString() => "Duration: ${duration}ms - Result: ${result}";
}
