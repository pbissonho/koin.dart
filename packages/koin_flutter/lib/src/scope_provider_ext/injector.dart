import 'package:flutter/widgets.dart';
import 'package:koin/koin.dart';

import 'scope_builder.dart';
import 'scope_provider.dart';

mixin ScopeProviderComponentMixin {
  ///
  /// Inject instance from Koin
  ///
  Lazy<T> inject<T>(BuildContext context,
      [Qualifier qualifier, List<Object> parameters]) {
    var scopeBuilder = ScopeProvider.of<ScopeBuilderComponent>(context);

    if (parameters != null) {
      return scopeBuilder.inject(qualifier: qualifier, parameters: parameters);
    } else {
      return scopeBuilder.get(qualifier, null);
    }
  }
}
