
/*
class ScopeBuilderComponent extends KoinComponent {
  final Qualifier scopeName;
  String id;

  ScopeBuilderComponent({@required this.scopeName});

  Scope get scope => getScope;

  Scope get getScope {
    return getKoin().getScope(id);
  }

  void init() {
    id = "${"IdTest"}@${scopeName.toString()}";
    getKoin().createScope(id, scopeName);
  }

  void close() {
    getKoin().deleteScope(id);
  }
}
*/