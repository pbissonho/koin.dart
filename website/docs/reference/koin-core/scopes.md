---
title: Scopes
---

Koin brings a simple API to let you define instances that are tied to a limit lifetime.

## What is a scope?

Scope is a fixed duration of time or method calls in which an object exists.
Another way to look at this is to think of scope as the amount of time an object’s state persists.
When the scope context ends, any objects bound under that scope cannot be injected again (they are dropped from the container).

## Scope definition

By default in Koin, we have 3 kind of scopes:

- `single` definition, create an object that persistent with the entire container lifetime (can't be dropped).
- `factory` definition, create a new object each time. Short live. No persistence in the container (can't be shared).
- `scoped` definition, create an object that persistent tied to the associated scope lifetime.

To declare a scoped definition, use the `scoped` function like follow. A scope gathers scoped definitions as a logical unit of time:

```dart
module()..scopeWithType(named('A Scope Name'),(scope){
  scope.scoped((s) => ComponentA());
});
```
:::note
A scope require a _qualifier_ to help name it. It can be either a String Qualifier, either a TypeQualifier
:::

Declaring a scope for a given type, can be done:

```dart
module()..scopeWithType(named<MyType>(),(scope){
  scope.scoped((s) => ComponentA());
});
```

or can even declared directly like this:

```dart
module()..scope<MyType>((scope){
  scope.scoped((s) => ComponentA());
});
```

## Using a Scope

Let's have those classes

```dart
class A {}
class B {}
class C {}
```

### Declare a Scoped Instance

Let's scope `B` & `C` instances from `A`, `B` & `C` instances are tied to a `A` instance:

```dart
module()
  ..factory((s) => A())
  ..scope<A>((scope) {
    scope.scoped((s) => B());
    scope.scoped((s) => C());
  });
```

### Create a scope and retrieve dependencies

Below is how we can create scope & retrieve dependencies

```dart
// Get A from Koin's main scope
var a = koin.get<A>()

// Get/Create Scope for `a`
var scopeForA = a.getOrCreateScope();

// Get scoped instances from `a`
var b = scopeForA.get<B>();
var c = scopeForA.get<C>();
```

We use the `getOrCreateScope` function, that will create a scope define by the type.
:::note
Note here that `scopeForA` is tied to `a` instance object
:::note

### Using the `scope` property

```dart
// Get A from Koin's main scope
var a = koin.get<A>()

// Get scoped instances from `a`
var b = a.scope.get<B>()
var c = a.scope.get<C>()
```

### Destroy scope and linked instances

```dart
// Destroy `a` scope & drop `b` & `c`
a.closeScope();
```

We use the `closeScope` function, to drop current scope & related scoped instances.

## More about Scope API

### Working with a scope

A scope instance can be created with as follow: `var scope = koin.createScope(id,qualifier);`. `id` is a ScopeId and `qualifier` the scope qualifier.

To resolve a dependency using the scope we can do it like:

* `var presenter = scope.get<Presenter>()` - directly using the get/inject functions from the scope instance

### Create & retrieve a scope

From your `Koin` instance you can access:

- `createScope(id : ScopeID, scopeName : Qualifier)` - create a closed scope instance with given id and scopeName
- `getScope(id : ScopeID)` - retrieve a previously created scope with given id
- `getOrCreateScope(id : ScopeID, scopeName : Qualifier)` - create or retrieve if already created, the closed scope instance with given id and scopeName

:::important
Make the difference between a scope instance id, which is the id to find your scope over all your scopes, and the scope name, which is the reference to the tied scope group name.
:::


### Resolving dependencies within a scope

The interest of a scope is to define a common logical unit of time for scoped definitions. It's allow also to resolve definitions from within the given scope

```dart
// given the classes
class ComponentA {}

class ComponentB {
  final ComponentA componentA;

  ComponentB(this.componentA);
}


// module with scope
module()
  ..scopeWithType(named("A_SCOPE_NAME"), (scope) {
    scope.scoped((s) => ComponentA());
    // will resolve from current scope instance
    scope.scoped((s) => ComponentB(s.get()));
  });
```

The dependency resolution is then straight forward:

```dart
// create an closed scope instance "myScope1" for scope "A_SCOPE_NAME"
var myScope1 = koin.createScope("myScope1",named("A_SCOPE_NAME"));

// from the same scope
var componentA = myScope1.get<ComponentA>();
var componentB = myScope1.get<ComponentB>();
```
:::important
By default, all scope fallback to resolve in main scope if no definition is found in the current scope
:::

### Closing a scope

Once your scope instance is finished, just closed it with the `close()` function:

```dart
// from a KoinComponent
var session = getKoin().createScope("session");

// use it ...

// close it
session.close();
```
:::important
Beware that you can't inject instances anymore from a closed scope.
:::

### Getting scope's source value

Koin Scope API in 2.1.4 allow you to pass the original source of a scope, in a definition. Let's take an example below.
Let's have a singleton instance `A`:

```dart
class A {}

class BofA {
  final A a;

  BofA(this.a);
}

var myModuleA = module()..single((s) => A())
  ..scope<A>((scope) {
    scope.scoped((s) => BofA(s.getSource()));
  });
```

By creating A's scope, we can forward the reference of the scope's source (A instance), to underlying definitions of the scope: `scoped { BofA(getSource()) }` or even `scoped { BofA(get()) }`

This in order to avoid cascading parameter injection, and just retrieve our source value directly in scoped definition.

```dart
var a = koin.get<A>()
var b = a.scope.get<BofA>()
expect(b.a, a);
```
:::note
> Difference between `getSource()` and `get()`: getSource will directly get the source value. Get will try to resolve any definition, and fallback to source
value if possible. `getSource()` is then more efficient in terms of performances.
:::


### Scope Linking

Koin Scope API allow you to link a scope to another, and then allow to resolve joined definition space. Let's take an example.
Here we are defining, 2 scopes spaces: a scope for A and a scope for B. In A's scope, we don't have access to C (defined in B's scope).

```dart
module()..single((s) => A())
  ..scope<A>((scope) {
    scope.scoped((s) => B());
  })..scope<B>((scope) {
    scope.scoped((s) => C());
  });
```

With scope linking API, we can allow to resolve B's scope instance C, directly from A'scope. For this we use `linkTo()` on scope instance:

```dart
var a = koin.get<A>();
// let's get B from A's scope
var b = a.scope.get<B>();
// let's link A' scope to B's scope
a.scope.linkTo(b.scope);
// we got the same C instance from A or B scope
expect(a.scope.get<C>(), b.scope.get<C>());
```

### Scope callback -- TODO


