DeComp is an architecture approach that allows developers to build highly scalable applications that
consist of many independent `Components`, each separated into a standalone package.

This approach allows several great benefits:

* 🎸 Component is self-sufficient and standalone; it encapsulates business logic (even complex cases) inside of it and allows greatly reduce code duplication
* 🧩 Components are reusable not only between different screens but also between multiple applications
* ⏱️ Each individual component can be developed independently
* 🔥 To embed a `Component` into our UI you need just one line of code

## How?

### What is a `Component`?

A component has its own Ui and business logic based on [bloc](https://pub.dev/packages/bloc) package. A Component specifies
what it can do (via `Events`), what data or/and events it can produce during its operation (via `Actions`) and what data
it needs to operate (via `ComponentRepository` contracts).

A component has zero clue about its environment: it does not depend on DI, localization approach, from where and how to get data. Each of those
tasks is forwarded to a dedicated abstraction level.

A component may contain other components inside of it, while still keeping up to the promise above.

### How does a `Component` gets embedded?

As stated above, a `Component` does not know much about how it's going to be used, nor how to get required data to operate.
It solely relies on its contracts to describe what it needs.

When we embed such `Component` into our application, we need to provide implementations of those contracts. Here comes the neat part:
we do that via `Coordinator` and a `View`.

#### `Coordinator`

A `Coordinator` is a class that describes how component (or even components inside that component) communicate with an "outside word" and each other.

### `View` 

A `View` sits above coordinator and has single purpose: to construct `Bloc` needed for our `Component` using your 
chosen approach: Singleton, DI or anything really.

This makes sense as we operate in a domain of the specific app you are building and not inside the `Component`, 
hence not hard-wiring any external dependencies and keeping our components standalone.

## Getting started

It's highly recommended to take a look at `/example` project to understand how it all ties together.
