import 'package:flutter/material.dart';
import 'package:koin/koin.dart';

import 'src/counter_example.dart';

void main() {
  startKoin((app) {
    app.printLogger(level: Level.debug);
//    app.module(counterModule);
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SimpleCounterPage());
  }
}
