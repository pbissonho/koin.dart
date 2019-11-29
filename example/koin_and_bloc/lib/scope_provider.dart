import 'package:flutter/widgets.dart';
import 'package:koin/koin.dart';
import 'package:koin_and_bloc/scope_builder.dart';
import 'package:provider/provider.dart';

class ScopeProvider extends ValueDelegateWidget<ScopeBuilder>
    implements SingleChildCloneableWidget {
  final Widget child;
  final Qualifier scopeName;

  ScopeProvider({
    Key key,
    Qualifier scopeName,
    Widget child,
  }) : this._(
            key: key,
            delegate: BuilderStateDelegate<ScopeBuilder>(
              (context) {
                return ScopeBuilder(scopeName: scopeName)..init();
              },
              dispose: (_, scope) {
                scope.close();
              },
            ),
            child: child,
            scopeName: scopeName);

  ScopeProvider._({
    Key key,
    @required ValueStateDelegate<ScopeBuilder> delegate,
    this.child,
    this.scopeName,
  }) : super(key: key, delegate: delegate);

  static T of<T>(BuildContext context) {
    try {
      return Provider.of<T>(context, listen: false);
    } on Object catch (_) {
      throw FlutterError(
        """
        Error when try get a Scope from context.
        Cause: ScopeProvider.of() called with a context that does not contain a Scope.
        Context: $context
        Possible solutions:  
        
        Provide a Scope for $context context.
          
          // A custom Scope
          ScopeProvider(
            scopeName: named("ScopeName"),
            child: WidgetName(),
          )

          // Or o scope root.
          ScopeProvider.root(
            child: WidgetName(),
          )

        """,
      );
    }
  }

  factory ScopeProvider.root({Key key, Widget child}) {
    return ScopeProvider._(
        key: key,
        delegate: BuilderStateDelegate<ScopeBuilder>(
          (context) {
            return ScopeBuilder(scopeName: StringQualifier("-Root-"))
              ..id = "-Root-";
          },
          dispose: (_, scope) {},
        ),
        child: child,
        scopeName: StringQualifier("-Root-"));
  }

  @override
  Widget build(BuildContext context) {
    return InheritedProvider<ScopeBuilder>(
      value: delegate.value,
      child: child,
    );
  }

  @override
  ScopeProvider cloneWithChild(Widget child) {
    return ScopeProvider._(
      key: key,
      scopeName: scopeName,
      child: child,
      delegate: delegate,
    );
  }
}
