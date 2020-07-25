import 'package:flutter/material.dart';
import 'package:koin/koin.dart';
import 'package:koin_flutter/koin_disposable.dart';
import 'package:koin_flutter/koin_flutter.dart';

abstract class BlocBase {
  void dispose();
}

class Bloc extends BlocBase with Disposable {
  bool isDisposed = false;

  @override
  void dispose() {
    isDisposed = true;
  }
}

class BlocComponentTest extends KoinComponent {
  Bloc blocX;

  BlocComponentTest() {
    blocX = get();
  }
}

class BlocComponentMixinTest with KoinComponentMixin {
  Bloc blocX;

  BlocComponentMixinTest() {
    blocX = get();
  }
}


final buttonKey = UniqueKey();
final fisrtPage = UniqueKey();
final secondPageKey = UniqueKey();

class ScopeWidget extends StatefulWidget {
  @override
  ScopeWidgetState createState() => ScopeWidgetState();
}

class ScopeWidgetState extends State<ScopeWidget> with ScopeStateMixin {
  Bloc bloc;

  @override
  void initState() {
    bloc = currentScope.get<Bloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: fisrtPage,
      body: Container(),
      bottomNavigationBar: GestureDetector(
        key: buttonKey,
        child: Icon(Icons.add),
        onTap: () {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return SecondPage();
          }), (t) => false);
        },
      ),
    );
  }
}

class WidgetNotUseScope extends StatefulWidget {
  @override
  WidgetNotUseScopeState createState() => WidgetNotUseScopeState();
}

class WidgetNotUseScopeState extends State<WidgetNotUseScope>
    with ScopeStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: fisrtPage,
      body: Container(),
      bottomNavigationBar: GestureDetector(
        key: buttonKey,
        child: Icon(Icons.add),
        onTap: () {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return SecondPage();
          }), (router) => false);
        },
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: secondPageKey,
      body: Container(
        child: Column(
          children: <Widget>[
            Text("Test"),
          ],
        ),
      ),
    );
  }
}

class UseScopeWidget extends StatefulWidget {
  @override
  UseScopeWidgetState createState() => UseScopeWidgetState(scope.get<Bloc>());
}

class UseScopeWidgetState extends State<UseScopeWidget> with ScopeStateMixin {
  final Bloc myBloc;

  UseScopeWidgetState(this.myBloc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: fisrtPage,
      body: Container(),
      bottomNavigationBar: GestureDetector(
        key: buttonKey,
        child: Icon(Icons.add),
        onTap: () {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return SecondPage();
          }), (t) => false);
        },
      ),
    );
  }
}

class UseScopeExtensionWidget extends StatefulWidget {
  @override
  UseScopeExtensionWidgetState createState() => UseScopeExtensionWidgetState();
}

class UseScopeExtensionWidgetState extends State<UseScopeExtensionWidget> {
  Bloc myBloc;

  @override
  void initState() {
    super.initState();
    myBloc = currentScope.get();
  }

  // Close the scope manually.
  @override
  void dispose() {
    currentScope.close();
    super.dispose();
  }

  UseScopeExtensionWidgetState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: fisrtPage,
      body: Container(),
      bottomNavigationBar: GestureDetector(
        key: buttonKey,
        child: Icon(Icons.add),
        onTap: () {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return SecondPage();
          }), (t) => false);
        },
      ),
    );
  }
}
