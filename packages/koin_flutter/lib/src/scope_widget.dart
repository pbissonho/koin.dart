import 'package:flutter/widgets.dart';
import 'package:koin_flutter/src/scope_component.dart';

class ScopeWidget extends StatefulWidget {
  @override
  _ScopeWidgetState createState() => _ScopeWidgetState();
}

class _ScopeWidgetState extends State<ScopeWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Carro {}

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with ScopeComponent {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
