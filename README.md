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
        - [Component definition](#component-definition)
        - [What should be a Component](#what-should-be-a-component)
        - [What should not be a Component](#what-should-not-be-a-component)
        - [Can Components have another Components inside?](#can-components-have-another-components-inside)
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

### Component definition

As we have discussed previously, a `Component` is a made-up word by which we mean a **self-sufficient piece of the app
**, which
has some **internal business logic**.

Following this definition, a `Component` consist of at least two parts (actually more, but for simplicity let's say so):

* Something to describe UI
* Something to describe Business Logic

For the first part it's simple, we already have `Widget`-s after all.

For the second part there are many options of implementations. `de_comp` is based on
a [bloc](https://pub.dev/packages/bloc)
package, so we also have an answer for that part.

To rephrase:
> A `Component`, in its simplest form, is a `Widget` paired with a `Bloc`.

`Component` can consist of many `Widget`-s, but should have at least one.

The latter part of our original definition, _has some internal business logic_, is important and is exactly what
differentiates between a `Widget` and a `Component`.

You can absolutely have some parts of your app still written as plain `Widget`-s in `de_comp`, but those
`Widget`-s should be "dumb", meaning there's no real Business Logic involved.

### Can Components have another Components inside?

Absolutely. Just like with plain `Widget`-s, you can have unlimited number of nested `Components` inside any
`Component`. The beauty of using `bloc` is that all `Bloc`-s for those `Components` would be passed down
via `Provider`-s. `de_comp` adds another layer of abstraction to allow you to have a defined contract of what `Bloc`-s
inner components require to operate inside a given "parent" `Component`.

### What should be a Component?

Almost **every screen** of your app should be a `Component`, **every part of a screen**, which has some internal logic,
should be a `Component`.

> If a piece of UI has another `Component`-s inside of it, it always has to be a `Component`.

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
those messages be displayed as a pop-up dialog upon some conditions. We still would write this `Component` only once
without
any code duplication.

#### 3. Voice assistant indicator

You know, that bubble that appears when you activate Siri.

It consists of some graphics elements (maybe different SVG images, or maybe a Lottie animation) as UI and has
some business logic: know current assistant's status (awaiting or processing a command), handle presses to execute
a new command and so on.

We most definitely might have this thing appear on multitude of different places throughout our app, and having all of
this
logic encapsulated inside has an immense benefit.

### What should NOT be a Component?

As we said previously, you absolutely can have plain `Widget`-s inside your app. The only requirement is that those
widgets
host no business logic, or very little of it with this logic having no data operations.

Pretty much all simple `Button`-s, `Text`-s and other `Widget`-s without internal Business Logic still should be just a
`Widget`.

Your UI should be split into smaller `Widget`-s. If something is not a screen, has no internal Business Logic,
and just takes some data and displays it, most likely it should not be a `Component`.

## Component embedding

A self-sufficient `Component` is great, but we still need to have our `Component` be displayed inside our app.
Thus, we need to "embed" it somewhere inside our layout.

Embedding can be split into two logical parts:

### Inserting a `Component`'s `Widget` inside your layout

Let's imagine that we have an abstract `Component` called `PhoneNumberTextField`; remembering our definition, it should
have a: `Widget` - `PhoneNumberTextFieldWidget` and a `Bloc` - `PhoneNumberTextFieldBloc`.

Now, let's say we want to add this `Component` to some part of our app, for example to our sing up form called
`SignUpWidget`.

We simply add `Component`'s `Widget` just like
you would with a plain `Widget`, which may look something like this:

```dart
@override
Widget build(BuildContext context) {
  return const Column(
    children: [
      ...
      PhoneNumberTextFieldWidget(),
      ...
    ],
  );
}
```

And that's the first part done! Notice, that we have zero dependencies here, nothing was passed to `Widget`'s
constructor.
That's the beauty of splitting embedding into two parts.

This approach shines even more if we were doing this embedding inside another `Component`, because it would not have to
know about any details of the `Component` we are embedding; just the name of that `Component`'s `Widget` is all it
needs!

### Providing required `Bloc` to our `Component`

Now that we have our `Component`'s `Widget` somewhere inside our layout, we need to utilize `Provider` mechanism to pass
down the layout required `Bloc` for our `Component`.

We discuss how and where exactly we do this later on in this documentation (in [View](#view) part), but for now it's
more
important just to differentiate between using a `Component`'s `Widget` somewhere inside your layout without any
dependencies
and knowing that we would pass those "dependencies" as this `Component`'s `Bloc` somewhere above later on.

Most importantly, we will do this not inside our `Component`, but inside our `Application`. There is a good reason
for that: to build an instance of our `Bloc`, we might need some external dependencies. And most likely those
dependencies are going to be inside your DI of choose. There's zero need for any of your `Component` to know anything
about it; decoupling `Bloc` initialization from `Component`'s visibility level allows you to change your DI approach
with zero changes made to your `Component`-s.

To recap:
> `Component` **does not** create an instance of its `Bloc`. Initialized `Bloc` is passed down to the `Component` via
`Provider`
> and is initialized inside application level. This allows us to decouple `Components` from any concrete implementations
> of DI.

As an abstract example, let's imagine that somewhere inside our app we write:

```dart
@override
Widget build(BuildContext context) {
  return BlocProvider(
    create: (_) => PhoneNumberTextFieldBloc(),
    child: const SignUpWidget(),
  );
}
```

> `SignUpWidget` is a `Widget` which was used in the previous example as a place where we have embedded our
`PhoneNumberTextFieldWidget`, so we have it as a child of our `BlocProvider`.

And that's it! We have successfully embedded our `Component`! Key points to summarize how we embed a `Component`:

* First we add our target `Component`'s `Widget` somewhere we need it to be inside the layout of the another `Component`
* Second we create an instance of our `Component`'s `Bloc` and pass it down via `BlocProvier` inside our `App`

## Component contracts

In the previous chapter we have discussed basic concepts that allow `Component` to be versatile, independent and easy to
use.

This is all possible because of the most important characteristics of a `Component`: is its self-sufficiency; meaning
that it has zero clue about the environment it is intended to be used. In order to do that, it has to rely on several
**contracts**, which will provide our `Component` will all the data it needs to operate.

### Event

The absolute basic contract of our `Component` is an `Event`. It frankly has almost zero difference with `Bloc`'s
definition.

> An `Event` specifies what a `Component` can do.

We can say that an `Event` is a public contract of our `Compoent` which describes its functionality.

From internal perspective,

> An `Event` is a way to notify our `Component`'s `Bloc` that something that our `Component` can do has happened.

Handling an `Event` usually means updating our `State`, which will trigger updating our UI.

Upon some `Event`-s we can change our `State` right away, let's say that `ConfirmPrivacyPolicyAgreement` should enable "
continue" button inside our UI after the user has read our privacy policy.

Upon some `Event`-s we might want to get some data, let's say that `UpdateWeatherForecastEvent` seems like a good
candidate to actually get up-to-date data about current weather and only then update our `State` with that new
information.

This is usual usage of `Events`, nothing new compared to how `Bloc` prescribes to use them. However, for `de_comp` we
need to pass extra responsibility to our `Event`-s for us to be possible to embed our `Component`-s with just one line
of code: we must pass initialization data via some `Event` as well.

> Most often this event may be called `InitializeEvent`.

What do we mean by "initialization data"? Here are some examples for our demo app:

* Some basic data: `ID` of a city to show weather forecast for
* Some flags: `showCompactForcast`, `hidePreviousHours`, `forceReload`, and so on

> Initialization data most definitely does not mean passing dependencies, as we already know that this is done upon
`Bloc` initialization.

This is extremely useful, because allows us to create `Bloc` **only once** upon loading specific screen containing our
`Bloc` but allows us to initialize it with different data multiple times.

For example, if we have a screen where one `Component` is responsible for choosing a city from a list and another
`Component` is responsible for showing weather for selected city, we can just call `InitializeEvent` every time our
selected city changes.

### Action

An action is a new concept introduced in `de_comp` which extends `Bloc` functionality and allows `Component` to notify
"outside world" about that something happened inside of it:

> An `Action` notifies external listeners that something has happened inside a `Component`.

In order to produce an `Action`, we still have to handle an `Event`. So an `Action` can be produces with a `State`
update
or instead of `State` update inside our `Bloc`.

Let's see how `Action`-s work by imagining a `WeatherSettingsComponent`, which allows user to set preferred temperature
unit (enum of `TemperatureUnit` with possible values of `celsius` and `fahrenheit`).

When we change selected unit inside our UI, an `Event`, describing selected unit, will be produced. We will handle this
`Event` inside of our `Bloc`, maybe somehow update `State` and produce an `Action`, let's say
`TemperatureUnitSelectedAction`, with selected `TemperatureUnit`. This would allow external observers to know about this
change.

By using `Actions` we can have multiple `Components` communicate between each other in an efficient way without even
knowing about one another. We will discuss how exactly this is done in later chapter.

### Localization Contract

Pretty much every app needs to be localized to different languages. Even if your app supports only one language (for now
of for good), it's still a wise decision to decouple actual strings from your code.

There are different approaches of how exactly to store those strings: built-in intl, 3-rd party services like Lokalise /
Localizely and others.

It's a good idea to have your application abstracted from specific chosen approach, because it can quite possibly change
as time goes by. Thus `de_comp` introduces localization contract, which comes shipped with every `Component`.

The interesting part is that this contract is bundled with our `BaseBloc`. This allows us several things:

1. Provide contract implementations upon `Bloc` creation in `Application` domain, thus having freedom of choosing and
   changing any approach for localization outside our `Component` domain
2. Having access to localization inside our `Bloc`, making it possible to handle advances niche cases of localization
3. Accessing our defined string inside our `Component`'s `Widget` as `bloc.string_name()`, uniforming this approach with
   usual `Bloc` access inside the `Widget`.

Such a contract is a pure `Dart` file, which defines all strings that a `Component` needs. For example:

```dart
abstract class MyComponentLocalizationContract extends BaseLocalization {
  String title(BuildContext context);

  String numberOfSelectedItems(BuildContext context, {
    required int itemsNumber,
  });

  String okButton(BuildContext context);

  String cancelButton(BuildContext context);
}
```

And that's it from the `Component`'s perspective. We don't care how exactly those strings are going to be implemented,
it's none of our `Component`'s concern.

Later on, inside our app, we can have multiple implementations of this contract, which implement different approaches;
let's say that we are cool with having just using plain strings for our debug builds, but want to use intl for release
builds to improve our localization flow using a dedicated team of translators.

For example, our string implementation would be:

```dart
class MyComponentLocalizationSimple extends MyComponentLocalizationContract {
  @override
  String title(BuildContext context) => 'My title';

  @override
  String numberOfSelectedItems(BuildContext context, {
    required int itemsNumber,
  }) =>
      'Selected items: $itemsNumber';

  @override
  String okButton(BuildContext context) => 'Ok';

  @override
  String cancelButton(BuildContext context) => 'Cancel';
}
```

For our intl implementation with such `.arb` file:
```json
{
  "title": "My cool title",
  "numberOfSelectedItems": "Selected items: {number}",
  "@numberOfSelectedItems": {
    "placeholders": {
      "number": {
        "type": "int"
      }
    }
  },
  "okButton": "Ok",
  "cancelButton": "Cancel"
}
```

Our contract implementation would be:

```dart
class MyComponentLocalizationIntl extends MyComponentLocalizationContract {
  @override
  String title(BuildContext context) => AppLocalizations.of(context).title;

  @override
  String numberOfSelectedItems(
    BuildContext context, {
    required int itemsNumber,
  }) =>
      AppLocalizations.of(context).numberOfSelectedItems(itemsNumber);

  @override
  String okButton(BuildContext context) => AppLocalizations.of(context).okButton;

  @override
  String cancelButton(BuildContext context) => AppLocalizations.of(context).cancelButton;
}
```

We have two different approaches of localizing applications under the same contract defined by our `Component`, and can
use them interchangeably without our `Component` knowing anything about it.

Using this contract inside our `Component`'s `Widget` is quite straightforward as well:

```dart
@override
Widget build(BuildContext context) {
  return Text(
    bloc.localization.numberOfSelectedItems(
      context,
      itemsNumber: 10,
    ),
  );
}
```

> As stated previously, localization contract is bundled with our `Bloc`, so we access our localization via `bloc` instance.

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
