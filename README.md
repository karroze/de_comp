DeComp is an architecture approach that allows developers to build highly scalable applications that
consist of many independent `Components`, each separated into a standalone package.

# Motivation

There are quite a few approaches to writing great apps in Flutter. However, none of them can be truly called an
architecture;
they sure do handle business logic, but that's about it.

And architecture should answer more questions than just that. To be sufficient, we should have uniformed
answers for many questions, some of which are:

* How do we organize our code?
* How do we layer our code and communicate between them?
* How do we transform data between different layers?
* How do we handle errors?
* How do we handle localization?

There is no doubt that many Flutter developers and teams have gathered enough expertise over the years to answer
some of those questions. However, there definitely is a need to have an actual architecture to have defined answers for
everyone.

So this is exactly what this project is all about.

By having "features" separated into `Component`-s, we have a foundation to answer all the questions mentioned above.

This approach allows several great benefits:

* 🎸 `Component` is self-sufficient and standalone; it encapsulates business logic inside and allows to reduce code
  duplication dramatically
* 🧩 `Component`-s are reusable not only between different parts of your app but also between multiple applications
* ⏱️ Each individual `Component` can be developed independently with almost zero integration hassle
* 🔥 To embed a `Component` into our UI you need just one line of code

# Index

- [Motivation](#motivation)
- [Index](#index)
- [Key concepts](#key-concepts)
    - [Component](#component)
    - [ComponentEmbedding](#component-embedding)
    - [Component Contracts](#component-contracts)
        - [Event](#event)
        - [Action](#action)
        - [LocalizationContract](#localization-contract)
        - [ComponentRepositoryContract](#component-repository-contract)
        - [ComponentViewContract](#component-view-contract)
    - [View]()
    - [Coordinator]()
- [Deciding what is a Component]()
- [Multi Package]()
  - [Motivation]()
  - [Using Melos]()

# Key concepts

## Component

### Basic definition

As we have discussed previously, a `Component` is a made-up word by which we mean a **self-sufficient piece of the app**, which
has some **internal business logic**.

Following this definition, a `Component` consist of at least two parts (actually more, but for simplicity let's say so):
* Something to describe UI
* Something to describe Business Logic

For the first part it's simple, we already have `Widget`-s after all. 

For the second part there are many options of implementations. `de_comp` is based on a [bloc](https://pub.dev/packages/bloc) 
package, so we also have an answer for that part.

To rephrase:
> A `Component`, in its simplest form, is a `Widget` paired with a `Bloc`.

`Component` can consist of many `Widget`-s, but should have at least one. 

The latter part of our original definition, _has some internal business logic_, is important and is exactly what 
differentiates between a `Widget` and a `Component`. 

You can absolutely have some parts of your app still written as plain `Widget`-s in `de_comp`, but those
`Widget`-s should be "dumb", meaning there's no real Business Logic involved.

### What should be a Component in my app?

Almost **every screen** of your app should be a `Component`, **every part of a screen**, which has some logic behind it, 
should be a `Component`.

Here are some real-life example of what other features that should be a `Component`:

#### 1. Text field which validates entered email.

It consists of a `TextField` widget and some logic of how to validate entered value. This logic can be simple, lets say 
a `Regex` for validation, or it can be more complex: we might want to send this value to our backend and perform some
sophisticated validation there. 

If there are 5 places in our app where we should have a text field of this type, we would benefit greatly to have this
logic encapsulated inside our `Component` and not written multiple times across different screens. 

#### 2. List of chat messages

It consists of a `ListView` (or `SliverList` if you want to be fancy) widget and some logic of how to get, maybe 
even how to sort and filter, that data (that's a little over-simplification, but is ok for now).

Here we obviously would benefit from having this piece of our app as a `Component` because we can have different places 
in which we might need to display this list of messages; let's say we might have a dedicated "chat screen" and also have
those messages be displayed as a pop-up dialog upon some conditions. We still would write this `Component` only once without
any code duplication.

#### 3. Voice assistant indicator

You know, that bubble that appears when you activate Siri. 

It consists of some graphics elements (maybe different SVG images, or maybe a Lottie animation) as UI and has 
some business logic: know current assistant's status (awaiting or processing a command), handle presses to execute 
a new command and so on. 

We most definitely might have this thing appear on multitude of different places throughout our app, and having all of this
logic encapsulated inside has an immense benefit.

### What should NOT be a Component?

As we said previously, you absolutely can have plain `Widget`-s inside your app. The only requirement is that those widgets
host no business logic, or very little of it and this logic has to have no data operations. 

Pretty much all simple `Button`-s, `Text`-s and other `Widget`-s without internal Business Logic still should be just a 
`Widget`. Your UI should be split into smaller `Widget`-s. If something is not a screen, has no internal Business Logic,
and just takes some data and displays it, most likely it should not be a `Component`.

## Component embedding

A self-sufficient `Component` is great, but we still 

## Component contracts

Second most important characteristics of a `Component` is its self-sufficiency, meaning that it has zero clue about the
environment it is intended to be used. In order to do that, it has to rely on several **contracts**, which will provide

### Event

### Action

### Localization Contract

### Component Repository Contract

### Component View Contract

## How?

### What is a `Component`?

A component has its own UI and business logic based on [bloc](https://pub.dev/packages/bloc) package.

A Component specifies what it can do (via accepting `Events`), what data or/and events it can produce during its
operation (via `Actions`) and what data
it needs to operate (via `ComponentRepository` contracts).

A component has zero clue about its environment: it does not depend on DI, navigation or localization approach,
even from where and how to get data. Each of those tasks is forwarded to a dedicated abstraction level.

A component may contain other components inside of it, while still keeping up to the promise above.

### How does a `Component` gets embedded?

As stated above, a `Component` does not know much about how it's going to be used, nor how to get required data to
operate.
It solely relies on its contracts to describe what it needs.

When we embed such `Component` into our application, we need to provide implementations of those contracts. Here comes
the neat part:
we do that via `Coordinator` and a `View`.

#### `Coordinator`

A `Coordinator` is a class that describes how component (or even components inside that component) communicate with an "
outside word" and each other.

### `View`

A `View` sits above coordinator and has single purpose: to construct `Bloc` needed for our `Component` using your
chosen approach: Singleton, DI or anything really.

This makes sense as we operate in a domain of the specific app you are building and not inside the `Component`,
hence not hard-wiring any external dependencies and keeping our components standalone.

## Getting started

There's a more in depth explanation of how all the concepts mentioned above ties up together in [Documentation](/docs).

Also, it's highly recommended to take a look at `/example` project to see this approach in action.
