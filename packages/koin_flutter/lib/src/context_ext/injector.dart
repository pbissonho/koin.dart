import 'package:flutter/widgets.dart';
import 'package:koin/koin.dart';
import 'package:koin_flutter/koin_flutter.dart';

mixin Injector {
  ///
  /// Inject instance from Koin
  /// @param qualifier
  /// @param parameters
  ///
  ///
  T inject<T>(BuildContext context,
      [Qualifier qualifier, List<Object> parameters]) {
    var scopeBuilder = ScopeProvider.of<ScopeBuilder>(context);

    if (parameters != null) {
      return scopeBuilder.get(qualifier, parametersOf(parameters));
    } else {
      return scopeBuilder.get(qualifier, null);
    }
  }
}
