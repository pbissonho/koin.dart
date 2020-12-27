typedef Initializer<T> = T? Function();

// TODO
// Remover a class Lazy

/// A class that provides lazy object initialization.
///
/// The [value] is initialized by the initializer function only when being
/// called for the first time.
///
/// Example of use:
///```
/// class Service {
///  final int id;
///
///  Service(this.id);
///}
///Lazy<Service> example = lazy(() => Service(10));
/// ```
///
/// Lazy value can be accessed by [call]  or [value] getter
///```
///print(example().id);
///
///print(example.value.id);
///  ```
///
class Lazy<T> {
  T? _value;

  final Initializer<T> _initializer;

  Lazy(this._initializer);

  ///
  /// Get the lazily initialized value.
  ///
  T? get value => _resolve();

  ///
  /// Returns whether the value has already been initialized or not.
  ///
  bool get isInitialized => _value != null;

  T? _resolve() {
    if (_value != null) return _value;
    _value = _initializer();
    return _value;
  }

  T? call() => _resolve();

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(other) {
    return other is Lazy && other.value == value;
  }
}

///
/// Creates a new instance of the [Lazy].
///
Lazy<T> lazy<T>(Initializer<T> initializer) => Lazy<T>(initializer);
