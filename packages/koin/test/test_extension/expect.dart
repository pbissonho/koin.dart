

import 'package:koin/src/core/global_context.dart';
import 'package:test/test.dart';

void expectHasNoStandaloneInstance() {
    expect(GlobalContext.instance.getOrNull(), isNull);
}