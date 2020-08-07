# DevTools 

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