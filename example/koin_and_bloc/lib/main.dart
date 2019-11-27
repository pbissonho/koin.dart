import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:koin/koin.dart';
import 'package:koin_and_bloc/counter_page.dart';

import 'di.dart';

class CounterEvent {}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    startKoin((app) {
      app.module(appModule);
    });
    super.initState();
  }

  @override
  void dispose() {
    stopKoin();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CounterPage(),
    );
  }
}
