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
