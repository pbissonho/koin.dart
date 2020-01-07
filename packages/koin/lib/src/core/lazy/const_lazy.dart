/// Creates a cons Lazy
///
///
/// /*

/*
class ConstLazy<T> implements Lazy<T> {
  static final _cache = Expando();

  final Initializer<T> _initializer;

  const ConstLazy(this._initializer);

  T call() => _resolve();

  T _resolve() {
    var result = _cache[this];
    if (result != null) return result;
    result = _initializer();
    _cache[this] = result;
    return result;
  }

  @override
  T get value => _resolve();

  @override
  bool get isInitialized => _cache[this] != null;
}
*/
