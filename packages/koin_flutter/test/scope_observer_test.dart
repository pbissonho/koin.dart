import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koin/koin.dart';
import 'package:koin_flutter/internals.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:koin_test/koin_test.dart';
import 'classes.dart';
import 'keys.dart';

final scopeProviderModule = Module()
  ..scope<FirstPage>((dsl) {
    dsl.scoped((scope) => Component(10));
  })
  ..scope<SecondPage>((dsl) {
    dsl.scoped((scope) => Component(10));
  });

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with ScopeStateMixin {
  @override
  Widget build(BuildContext context) {
    final bloc = currentScope.get<Component>();
    return Scaffold(
        key: firstPageKey,
        appBar: AppBar(
          title: Text("First Page"),
        ),
        body: Column(
          children: [
            Center(
              child: Text(bloc.id.toString()),
            ),
            FlatButton(
              key: buttonKey,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SecondPage();
                }));
              },
              child: Text("Push Second Page"),
            ),
          ],
        ));
  }
}

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> with ScopeStateMixin {
  @override
  Widget build(BuildContext context) {
    final component = currentScope.get<Component>();

    return Scaffold(
      key: secondPageKey,
      body: Text(component.id.toString()),
    );
  }
}

void main() {
  setUp(() {
    startKoin((app) {
      app.module(scopeProviderModule);
    });
  });

  koinTearDown();

  testWidgets('shoud observer the escope', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: FirstPage(),
    ));

    final firstPageFinder = find.byKey(firstPageKey);
    final secondPageFinder = find.byKey(secondPageKey);
    final buttonFinder = find.byType(FlatButton);
    final textFinder = find.text('10');

    expect(firstPageFinder, findsOneWidget);
    expect(
        FlutterKoinScopeObserver.scopeWidgetObserver.scopeContexts.length, 1);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    expect(secondPageFinder, findsOneWidget);
    expect(
        FlutterKoinScopeObserver.scopeWidgetObserver.scopeContexts.length, 2);

    expect(textFinder, findsOneWidget);
  });
}
