
## 0.15.0-nullsafety.0 

- Fix analysis issues
- BREAKING: Migrate to null-safety
- BREAKING: "inject" removed.


## 0.14.2

- Fix pub analysis issues

## 0.14.1
- Update readme
- Update dependencies

## 0.14.0

- Update readme
- Refactoring performed to improve code maintenance
- Breaking changes
  * `get`, `inject` and `bind` methods no longer allows parameter passing, use `injectWithParam`, `getWithParam` and `bindWithParam`.
  * `getWithParams` and `injectWithParams` renamed to `getWithParam` and `injectWithParam`.

  * It will no longer be possible to pass a list of parameters. Now it is only possible to pass a single parameter.This change was made to make the API more accurate and to avoid errors.
    * factory1, factory2 and factory3 have been replaced by factoryWithParam
    * single1, single2 and single3 have been replaced by singleWithParam
    * scoped1, scoped2 and scoped3 have been replaced by scopedWithParam

   How to pass a list of parameters?
   R: Insert the parameters as properties of a class.

   Example:
```dart
    class MyClass {
      final int param1;
      final String param2;

      MyClass(this.param1, this.param2);

      void doDomething() {
        print("$param1 $param2");
      }
    }

    class MyClassParam {
      final int param1;
      final String param2;

      MyClassParam(this.param1, this.param2);
    }

    final koinModule = Module()
      ..singleWithParam<MyClass, MyClassParam>(
          (s, p) => MyClass(p.param1, p.param2));

    class App with KoinComponentMixin {
      App() {
        final myClass =
            getWithParam<MyClass, MyClassParam>(MyClassParam(10, "Hello"));
      }
    }   
```
    

- Added asyncStartKoin function to allow the koin to start asynchronously.

## 0.13.1+1

- Update readme

## 0.13.1

- Internal improvements
- Update readme

## 0.13.0

- Export 'instance_factory.dart'
- Refactoring
- Make private members that shouldn't be public.
  * These methods were not in the main API or in the documentation, so don't worry.
    
## 0.12.1

- Fix pub analysis issues

## 0.12.0

- Update readme
- Improvements in error handling.
- Loggger improvements.
- Added `createScopeWithQualifier` and `createScopeWithSource` to the scope API.
- Added the `scopeOne` declaration method.
 * Allows you to declare a 'scoped' definition and a scope with just one line.
 * Used for scopes that have only one definition.

- Breaking changes
 * Remove the createScopeT metohod from scope API.
 * Remove the `qualifier` parameter from createScope.

    Before:
    ```dart
    var scope2 = koin.createScope('myScope', named<ScopeType>());
    ```  
    Now:
    ```dart
    var scope2 = koin.createScope<ScopeType>('myScope');
    ```  


## 0.11.0+1

- Update readme

## 0.11.0

- Added `getWithParams`, `injectWithParams` and `bindWithParams` methods in `scope` and `KoinComponent`.
- Update readme

- Breaking changes
 
 * Removed some exports that shouldn't be visible.


## 0.10.0

- Breaking changes

    The `getOrCreateScopeT()` function renamed to `getOrCreateScope()`
    The `getOrCreateScope()` function renamed to `getOrCreateScopeQualifier()`   
    
    How to use now:
    ```dart
    var scope2 = koin.getOrCreateScopeQualifier('myScope', named<ScopeType>());
    var scope3 = koin.getOrCreateScope<ScopeType>('myScope');
    ```   

- The parameters of `getWithType ()`, `getOrNullWithType ()` are now optional.
- Operator '+' of class Module was rewritten.
    It is now possible to return a list from the sum of two modules.
    ```dart
    var mods = modA + modB;
    expect(mods, [modA, modB]);
    ```
- Fixed an error in creating the root scope
- Fixed an error in creating the root scope
- Update readme
- Added more tests

## 0.9.1

- Fixed a error when use `bind()`
- Update readme
- Added more tests

## 0.9.0

- Fixed the error when closing a definition that the value was not instantiated.
- Export `KoinContextHandler`

## 0.8.0

- Code improvements with pub.dev health suggestions
- Moved Scope extensions to `instance_scope_ext.dart`
- Update dependencies

## 0.7.2

- Fixed an error on Scope create

## 0.7.1

- Fixed an error when drop a factory instance

## 0.7.0

- Added more tests. Coverage 80%
- Refactoring and restructuring from koin 2.1.5
- Update readme

## 0.3.2+3

- Update readme

## 0.3.2+2

- Update readme

## 0.3.2+1

- Update description
- Code improvements with pub.dev health suggestions

## 0.3.2+1

- Update description
- Code improvements with pub.dev health suggestions

## 0.3.2

- Added NullParameterFoundException
- Remove Analysis reports

## 0.3.1

- Exported lazy class

## 0.3.0

- Parameters of the definition functions configured as named
- All documentation set to dart standards
- More tests added
- Lazy rewritten

## 0.2.0

- Added Lazy inject

## 0.1.0

- Initial version
