# Getting Started with Flutter application

> This tutorial lets you write an Flutter/Dart application and use Koin inject and retrieve your components.

## Get the code

Checkout the project directly on Github or download the zip file

> 🚀 Go to [Github](https://github.com/InsertKoinIO/getting-started-koin-Flutter) or [download Zip](https://github.com/InsertKoinIO/getting-started-koin-Flutter/archive/master.zip)

## Gradle Setup

Add the Koin Flutter dependency like below:

dependencies:
  koin: ^[laste_version]
  koin_fluter: ^[laste_version]

## Our components

Let's create a HelloRepository to provide some data:

```dart
class HelloRepository {
  giveHello() => "Hello Koin";
}
```

Let's create business logic class, for consuming this data:

```dart
class MyBloc {
  final HelloRepository helloRepository;

  MyBloc(this.helloRepository);
}
```


## Writing the Koin module

Use the `module` function to declare a module. Let's declare our first component:

```dart
// just declare it
var myModule = Module()
    ..single((s) => HelloRepository())
    ..factory((s) => MyBloc(s.get()));
```

?> we declare our MySimplePresenter class as `factory` to have a create a new instance each time our Widget will need one.

## Start Koin

Now that we have a module, let's start it with Koin. Open your application class, or make one (don't forget to declare it in your manifest.xml). Just call the `startKoin()` function:

```dart
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    startKoin((app) {
      app.printLogger(level: Level.debug);
      app.modules(myModule)
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage());
  }
}
```

## Injecting dependencies

The `MyBloc` component will be created with `HelloRepository` instance. To get it into our Widget, let's inject it with the `by get()` delegate injector: 

```dart
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // Get a dependency
    var controller = get<MyBloc>();
    return Container(
      child: Text("${controller.toString()}"),
    );
  }
}
```

?> The `by inject()` function allows us to retrieve lazy Koin instances

?> The `get()` function is here to retrieve directly an instance (non lazy)

