import '../koin_application.dart';
import '../module.dart';
import 'context.dart';
import 'context_handler.dart';

///
/// Start a Koin Application as StandAlone
///
KoinApplication startKoin(Function(KoinApplication app) appDeclaration,
    {KoinContext? koinContext}) {
  koinContext ??= GlobalContext();
  KoinContextHandler.register(koinContext);
  var koinApplication = KoinApplication.init();
  KoinContextHandler.start(koinApplication);
  appDeclaration(koinApplication);
  koinApplication.createEagerInstances();
  return koinApplication;
}

///
/// Start a Koin Application as StandAlone
///
Future<void> asyncStartKoin(Function(KoinApplication app) appDeclaration,
    {KoinContext? koinContext}) async {
  await Future.microtask(() {
    startKoin(appDeclaration, koinContext: koinContext);
  });
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
