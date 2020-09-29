import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koin/koin.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:koin_test/koin_test.dart';

final buttonKey = UniqueKey();
final fisrtPage = UniqueKey();
final secondPageKey = UniqueKey();

class Component {
  const Component(this.id);

  final int id;
}

final scopeProviderModule = Module()
  ..scope<FirstPage>((dsl) {
    dsl.scoped((scope) => Component(10));
  });

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    final bloc = currentScope.get<Component>();
    return Scaffold(
        key: fisrtPage,
        appBar: AppBar(
          title: Text("Home Page"),
        ),
        body: Column(
          children: [
            Center(
              child: Text(bloc.id.toString()),
            ),
            FlatButton(
              key: buttonKey,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return ScopeProvider(
                      child: SecondPage(), scope: currentScope);
                }));
              },
              child: Text("Push Second Page"),
            ),
          ],
        ));
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final component = context.scope.get<Component>();

    return Scaffold(
      key: secondPageKey,
      body: Text(component.id.toString()),
    );
  }
}

void main() {
  Koin koin;

  setUp(() {
    koin = startKoin((app) {
      app.module(scopeProviderModule);
    }).koin;
  });

  koinTearDown();

  testWidgets('shoud get the scope passed to the context', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: FirstPage(),
    ));

    final fisrtPageFinder = find.byKey(fisrtPage);
    final secondPageFinder = find.byKey(secondPageKey);
    final buttonFinder = find.byType(FlatButton);
    final textFinder = find.text('10');

    expect(fisrtPageFinder, findsOneWidget);

    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    expect(secondPageFinder, findsOneWidget);

    expect(textFinder, findsOneWidget);
  });
  testWidgets('shoud trow a exception when the context does not have a scope',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SecondPage(),
    ));

    expect(tester.takeException(), isInstanceOf<ScopeNotFoundException>());
  });
}
