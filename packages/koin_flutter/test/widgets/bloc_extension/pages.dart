import 'package:flutter/material.dart';
import 'package:koin/koin.dart';
import 'package:koin_flutter/koin_disposable.dart';
import 'package:koin_flutter/koin_flutter.dart';

abstract class BlocBase {
  void dispose();
}

class Bloc extends BlocBase implements Disposable {
  bool isDisposed = false;

  @override
  void dispose() {
    isDisposed = true;
  }
}

class BlocComponentTest extends KoinComponent {
  BlocComponentTest() {
    blocX = get();
  }
  late Bloc blocX;
}

class BlocComponentMixinTest with KoinComponentMixin {
  BlocComponentMixinTest() {
    blocX = get();
  }
  late Bloc blocX;
}

final buttonKey = UniqueKey();
final fisrtPage = UniqueKey();
final secondPageKey = UniqueKey();

class ScopeWidget extends StatefulWidget with HotRestartScopeMixin {
  @override
  ScopeWidgetState createState() => ScopeWidgetState();

  @override
  Widget get route => ScopeWidget();
}

class ScopeWidgetState extends State<ScopeWidget> with ScopeStateMixin {
  late Bloc bloc;

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
              MaterialPageRoute(builder: (context) {
            return SecondPage();
          }), (t) => false);
        },
      ),
    );
  }
}

class WidgetNotUseScope extends StatefulWidget with HotRestartScopeMixin {
  @override
  WidgetNotUseScopeState createState() => WidgetNotUseScopeState();

  @override
  Widget get route => WidgetNotUseScope();
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
              MaterialPageRoute(builder: (context) {
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

class UseScopeWidget extends StatefulWidget with HotRestartScopeMixin {
  @override
  UseScopeWidgetState createState() => UseScopeWidgetState(scope.get<Bloc>());

  @override
  Widget get route => UseScopeWidget();
}

class UseScopeWidgetState extends State<UseScopeWidget> with ScopeStateMixin {
  UseScopeWidgetState(this.myBloc);

  final Bloc myBloc;

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
              MaterialPageRoute(builder: (context) {
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
  late Bloc myBloc;

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
              MaterialPageRoute(builder: (context) {
            return SecondPage();
          }), (t) => false);
        },
      ),
    );
  }
}
