import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:koin_flutter/internals.dart';
import 'package:koin/instance_factory.dart';
import 'package:koin/internals.dart';
import 'package:kt_dart/kt.dart';

class _DevTools {
  static Map<String, ScopeWidgetContext> koinContextScopes() {
    final scopesMap = <String, ScopeWidgetContext>{};
    scopesMap['Root'] = ScopeWidgetContext(
      KoinDebugDefaultWidget(),
      KoinContextHandler.get().scopeRegistry.rootScope,
    );
    scopesMap
        .addAll(FlutterKoinScopeObserver.scopeWidgetObserver.scopeContexts);
    return scopesMap;
  }
}

/// Push a new route with [KoinDevTools] Widget.
void showDevTools(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
    return KoinDevTools();
  }));
}

/// [Widget] that allows you to view or koin scopes.
/// It allows viewing the internal state of the instances.
///
/// And perform a hot restart of only one scope, the hot restart button will recreate
/// the scope and rebuild the widget scope.
class KoinDevTools extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text("Koin DevTools"),
        ),
        body: _ScopesListWidget(
          scopes: _DevTools.koinContextScopes(),
        ),
      ),
    );
  }
}

class _ScopesListWidget extends StatelessWidget {
  final Map<String, ScopeWidgetContext> scopes;

  const _ScopesListWidget({Key? key, required this.scopes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var list = scopes.values.toList();
    return ListView.builder(
      itemCount: scopes.length,
      itemBuilder: (BuildContext context, int index) {
        return _ScopeCard(scopeContext: list[index]);
      },
    );
  }
}

class _ScopeCard extends StatefulWidget {
  final ScopeWidgetContext scopeContext;

  const _ScopeCard({Key? key, required this.scopeContext}) : super(key: key);

  @override
  _ScopeCardState createState() => _ScopeCardState();
}

class _ScopeCardState extends State<_ScopeCard> {
  @override
  Widget build(BuildContext context) {
    var views = <_FactoryViewer>[];

    widget.scopeContext.scope
        .getAllInstanceFactory()
        .dart
        .forEach((instanceFactory) {
      views.add(_FactoryViewer(instanceFactory, widget.scopeContext.scope));
    });

    final widgetType = widget.scopeContext.widgetScopeSource.runtimeType.toString();
    final widgetName = widgetType == "KoinDebugDefaultWidget" ? "" : widgetType;

    return ExpandableNotifier(
        child: Padding(
      padding: EdgeInsets.all(10),
      child: ScrollOnExpand(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              ExpandablePanel(
                theme: ExpandableThemeData(
                  useInkWell: true,
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToExpand: true,
                  tapBodyToCollapse: false,
                  hasIcon: false,
                ),
                collapsed: Text("Collapased"),
                header: Container(
                  color: Colors.indigoAccent,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        ExpandableIcon(
                          theme: ExpandableThemeData(
                            expandIcon: Icons.arrow_right,
                            collapseIcon: Icons.arrow_drop_down,
                            iconColor: Colors.white,
                            iconSize: 28.0,
                            iconRotationAngle: 3.14 / 2,
                            iconPadding: EdgeInsets.only(right: 5),
                            hasIcon: false,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            '${widgetName}  Id:${widget.scopeContext.scope.id.toString()}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                expanded: ListView.builder(
                  itemCount: views.length,
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (_, index) {
                    return _InstanceWidget(instanceViewer: views[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

class _FactoryViewer {
  final InstanceFactory _instanceFactory;
  final Scope _scope;
  ProviderDefinition get _beanDefinition => _instanceFactory.beanDefinition;
  String get instanceToString {
    if (_instanceFactory is FactoryInstanceFactory)
      return "The instance is not stored.";
    return _instanceFactory
        .get(InstanceContext(
            koin: _instanceFactory.koin,
            scope: _scope,
            parameter: emptyParameter()))
        .toString();
  }

  String get primaryType => _beanDefinition.primaryType.toString();
  String get kind => _beanDefinition.kind.toString();
  String get qualifier {
    if (_beanDefinition.qualifier != null) {
      return _beanDefinition.qualifier.toString();
    }
    return 'Without qualifier.';
  }

  _FactoryViewer(this._instanceFactory, this._scope);
}

class _InstanceWidget extends StatelessWidget {
  final _FactoryViewer instanceViewer;

  const _InstanceWidget({Key? key, required this.instanceViewer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        onTap: () {
          _showFactoryViewerDialog(context, instanceViewer);
        },
        trailing: Text(instanceViewer.kind),
        subtitle: Text("Qualifier: ${instanceViewer.qualifier}"),
        title: Text(instanceViewer.primaryType),
      ),
    );
  }
}

Future<void> _showFactoryViewerDialog(
    context, _FactoryViewer factoryViewer) async {
  showDialog<_FactoryViewer>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.all(18),
          title: Center(child: Text(factoryViewer.primaryType.toString())),
          children: <Widget>[
            Text("Qualifier: ${factoryViewer.qualifier}"),
            Text(
              "State: ${factoryViewer.instanceToString}",
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      });
}

class KoinDebugDefaultWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}