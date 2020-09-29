## 0.10.0

- Added ScopeProvider to allow passing a scope down the widget tree
- It will no longer be possible to pass a list of parameters. Now it is only possible to pass a single parameter.

## 0.9.6

- Improvements in ScopeWidgetObserver

## 0.9.5

- Added ScopeWidgetObeserver

## 0.9.4

- Export `Disposable` on koin_bloc.dart import.

## 0.9.3

- Depreciated `bloc` and `scopedBloc`. With the launch of the "koin_bloc" package, these methods will be removed in the next versions to avoid confusion.
  
  * Now use `disposable` and `scopedDisposable`
  
  Pass to use:

  ```dart
   final blocModule = Module()..disposable((s) => Bloc());
  ```
  ```dart
  final blocModule = Module()
  ..scope<ScopeWidget>((scope) {
     scope.scopedDisposable<ScopedBloc>((s) => ScopedBloc());
   });
  ```

- Documentation improvements.

## 0.9.2

- Fix internal error.

## 0.9.1

- Update to koin v0.12.0
- Internal improvements.

## 0.9.0

- Added `currentScope` method as extension for State class.
   * It is now possible to use `currentScope.get ()` instead of `widget.scope.get ()`
- Fixed an error in scope object extension.
- Added `ScopeStateMixin`. A mixin to be used in widgets states for close the koin scope automatically.

- Breaking changes
 
 * Removed the use of scopes methods in all Widgets.
   * Now it is only possible to use the scope methods in 'StatefulWidget' widgets.
 * Removed the `bloc()` to obtain a bloc instance. Just use `get()` or `currentScope.get()` for that.
 * Removed `getScopeOrNull()`, `createScope()`, `getOrCreateScope ()` and `scopeName` methods from public flutter scope extension.
   

## 0.6.3
- Change to Koin 0.10.0
- Added Scope Widgets extensions
   - Now it is no longer necessary to import 'instance_scope_ext.dart', just import 'koin_flutter.dart' in order to use the scope functions.

## 0.6.1

- Added Widgets extensions
    - Now it is no longer necessary to use 'KoinComponentMixin',just import 'koin_flutter.dart' "and use the 'get', 'bind' and 'inject' methods in the Flutter Widgets; 

## 0.6.0

- Added BlocExtension as extension
- Testructuring to Koin 0.8.0
- Removed ScopeComponentMixin, Scopeprovider and ScopeBuilder

## 0.3.0

- Added BlocExtension
- Minor improvements
- Change to Koin 0.3.2
- ScopeComponent renamed to ScopeComponentMixin

## 0.2.0

- Added ScopeComponent
- Minor improvements

## 0.1.0

- Initial version


