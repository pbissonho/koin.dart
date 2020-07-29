import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:koin/koin.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:kt_dart/kt.dart';
import 'package:koin/instance_factory.dart';

class _DevTools {
  Map<String, ScopeWidgetContext> koinContextScopes() {
    final scopesMap = <String, ScopeWidgetContext>{};
    scopesMap['Root'] = ScopeWidgetContext(
        null, KoinContextHandler.get().scopeRegistry.rootScope, null);
    scopesMap.addAll(scopeObserver.scopeContexts);
    return scopesMap;
  }
}

void showDevTools(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
    return KoinDevTools();
  }));
}

class KoinDevTools extends StatelessWidget {
  final _DevTools devTools = _DevTools();

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
        body: ScopesListWidget(
          scopes: devTools.koinContextScopes(),
        ),
      ),
    );
  }
}

class ScopesListWidget extends StatelessWidget {
  final Map<String, ScopeWidgetContext> scopes;

  const ScopesListWidget({Key key, this.scopes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var list = scopes.values.toList();
    return ListView.builder(
      itemCount: scopes.length,
      itemBuilder: (BuildContext context, int index) {
        return ScopeCard(scopeContext: list[index]);
      },
    );
  }
}

class ScopeCard extends StatefulWidget {
  final ScopeWidgetContext scopeContext;

  const ScopeCard({Key key, this.scopeContext}) : super(key: key);

  @override
  _ScopeCardState createState() => _ScopeCardState();
}

class _ScopeCardState extends State<ScopeCard> {
  @override
  Widget build(BuildContext context) {
    var views = <FactoryViewer>[];

    widget.scopeContext.scope
        .getAllInstanceFactory()
        .dart
        .forEach((instanceFactory) {
      views.add(FactoryViewer(instanceFactory, widget.scopeContext.scope));
    });

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
                            '${widget.scopeContext.widgetScopeSource?.runtimeType ?? ''}  Id:${widget.scopeContext.scope.id.toString()}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        /* 
                        Expanded(
                            flex: 1,
                            child: LayoutBuilder(
                              builder: (BuildContext context,
                                  BoxConstraints constraints) {
                                if (widget
                                    .scopeContext.scope.scopeDefinition.isRoot)
                                  return Container(
                                    child: Text("Root"),
                                  );

                                return IconButton(
                                  icon: Icon(Icons.restore),
                                  onPressed: () {
                                    widget.scopeContext.hotRestartScope();
                                  },
                                );
                              },
                            )),*/
                      ],
                    ),
                  ),
                ),
                expanded: ListView.builder(
                  itemCount: views.length,
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (_, index) {
                    return InstanceWidget(instanceViewer: views[index]);
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

class FactoryViewer {
  final InstanceFactory _instanceFactory;
  final Scope _scope;
  BeanDefinition get _beanDefinition => _instanceFactory.beanDefinition;
  //final bool created;
  String get instanceToString {
    if (_instanceFactory is FactoryInstanceFactory)
      return "The instance is not stored.";
    return _instanceFactory
        .get(InstanceContext(
            koin: _instanceFactory.koin, scope: _scope, parameters: null))
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

  FactoryViewer(this._instanceFactory, this._scope);
}

class InstanceWidget extends StatelessWidget {
  final FactoryViewer instanceViewer;

  const InstanceWidget({Key key, this.instanceViewer}) : super(key: key);

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
    context, FactoryViewer factoryViewer) async {
  showDialog<FactoryViewer>(
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
