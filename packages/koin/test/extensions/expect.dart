import 'package:koin/src/context/context_handler.dart';
import 'package:test/test.dart';

void expectHasNoStandaloneInstance() {
  expect(KoinContextHandler.getOrNull(), isNull);
}
