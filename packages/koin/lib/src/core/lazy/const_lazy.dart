/*

import 'lazy.dart';
class ConstLazy<T> {
  static final _cache = Expando();

  final Initializer<T> initializer;

  const ConstLazy(this.initializer);

  ///
  /// Get the lazilyinitialized value.
  ///
  T get value => _resolve();

  ///
  /// Returns whether the value has already been initialized or not.
  ///
  bool get isInitialized => _cache[this] != null;

  T _resolve() {
    var result = _cache[this];
    if (result != null) return result;
    result = initializer();
    _cache[this] = result;
    return result;
  }

  T call() => _resolve();
}
*/
