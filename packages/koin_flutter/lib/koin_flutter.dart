library koin_flutter;

import 'package:koin/internals.dart';
import 'package:koin/koin.dart';
import 'internals.dart';
export 'src/widget_extension.dart';

///
/// Start a Koin Application as StandAlone
///
KoinApplication startFlutterKoin(Function(KoinApplication app) appDeclaration,
    {KoinContext koinContext}) {
  final koinApplication = startKoin(appDeclaration, koinContext: koinContext);
  KoinContextHandler.get().withScopeObserver(FlutterKoinObserver.scopeObserver);
  return koinApplication;
}
