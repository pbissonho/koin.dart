## 0.11.1
- Change koin version.
- Added tests

## 0.11.0

- Added support koin v0.8.0

## 0.10.0

- Restructuring to support koin v0.7.2

## 0.7.0

- Added extension functions to module test
- Update readme
- Renamed moduleTest to testModule
- Renamed modulesTest to testModules

## 0.5.0

- Added functions to improve koin tests.
    - `koinTest` Configures the testing environment to automatically start and `close Koin.
    - `koinSetUp` Register a setUp function that starts koin before tests.
    - `koinTearDown` Register a tearDown function that close Koin afters tests.
    - `inject` Lazy inject an instance from Koin in the test environment.
    - `get` Get an instance from Koin in the test environment.


- Support for koin 0.2.0

## 0.2.0

- Support for koin 0.2.0

## 0.1.0

- Initial version
