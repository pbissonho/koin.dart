import 'package:koin/src/core/context/koin_context_handler.dart';
import 'package:test/test.dart';

void expectHasNoStandaloneInstance() {
  expect(KoinContextHandler.getOrNull(), isNull);
}
