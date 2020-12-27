# koin_devtools

### A DevTools to Koin.dart.  

Koin DevTools allows you to inspect the internal state of the objects created by the providers(definitions).

# Demo

![alt-text](https://github.com/pbissonho/koin.dart/blob/master/devtools.gif)

# Usage

Just insert the KoinDevTools Widget somewhere in your application or use showDevTools.

```dart
class Page extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     /// Just insert the KoinDevTools
      endDrawer: KoinDevTools(),
      body: IconButton(icon: Text('DevTools'), onPressed: () {
        // Or use this
        showDevTools(context);
      },),
    );
  }
}
```