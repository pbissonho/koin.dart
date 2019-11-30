import 'package:flutter_test/flutter_test.dart';
import 'package:koin/koin.dart';
import 'package:koin_and_bloc/di.dart';

void main() {
  test("description", () {
    var app = startKoin((app) {
      app.modules([appModule]);
    });

    var local = KoinApplication()..koin;
  });
}

// 169.640.397-26
