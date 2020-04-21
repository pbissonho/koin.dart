import 'package:koin/src/core/context/koin_context.dart';
import 'package:koin/src/core/context/koin_context_handler.dart';

import '../../../koin.dart';
import '../koin_application.dart';
import 'global_context.dart';

///
/// Start a Koin Application as StandAlone
///
KoinApplication startKoin(
    {KoinApplication koinApplication, KoinContext koinContext}) {
  koinContext ??= GlobalContext();
  KoinContextHandler.register(koinContext);
  KoinContextHandler.start(koinApplication);
  koinApplication.createEagerInstances();
  return koinApplication;
}

KoinApplication startKoin2(
    KoinApplication Function(KoinApplication koin) appDeclaration,
    {KoinContext koinContext}) {
  koinContext ??= GlobalContext();
  var koinApplication = KoinApplication.init();
  KoinContextHandler.start(koinApplication);
  appDeclaration(koinApplication);
  koinApplication.createEagerInstances();
  return koinApplication;
}

///
/// Stop current StandAlone Koin application
///
void stopKoin() => KoinContextHandler.stop();

///
/// Load a Koin module in global Koin context
///
void loadKoinModule(Module module) {
  KoinContextHandler.get().loadModule(module);
}

///
/// Load Koin a list of modules in global Koin context
///
void loadKoinModules(List<Module> modules) {
  KoinContextHandler.get().loadModules(modules);
}

///
/// Unload Koin modules from global Koin context
///
void unloadKoinModule(Module module) {
  KoinContextHandler.get().unloadModule(module);
}

///
/// Unload Koin modules from global Koin context
///
void unloadKoinModules(List<Module> modules) {
  KoinContextHandler.get().unloadModules(modules);
}
