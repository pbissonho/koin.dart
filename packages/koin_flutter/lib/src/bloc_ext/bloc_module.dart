import 'package:koin/koin.dart';

// Todo

// bloc<Type>(WidgetScope)

// Cada bloc ter um scopo.

mixin Disposable {
  void dispose();
}


class BlocModule extends Module {
  BeanDefinition<T> bloc<T extends Disposable>(
    Definition<T> definition, {
    Qualifier qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    BeanDefinition<T> beanDefinition =
        BeanDefinition<T>.createSingle(qualifier, null, definition);
    declareDefinition(beanDefinition,
        Options(isCreatedAtStart: createdAtStart, override: override));

    beanDefinition.onClose((bloc) {
      if (logger.isAt(Level.debug)) {
        logger.debug("{$T BLoC closed}");
      }

      bloc.dispose();
    });
    return beanDefinition;
  }

  @override
  ScopeSet scope(
      Qualifier scopeName, Function(BlocScopeSet scope) scopeDeclaration) {
    var scopeX = BlocScopeSet(scopeName);
    scopeDeclaration(scopeX);
    declareScope(scopeX);
    return scopeX;
  }
}

class BlocScopeSet extends ScopeSet {
  BlocScopeSet(Qualifier scopeName) : super(scopeName);

  BeanDefinition<T> scopedBloc<T extends Disposable>(
      [Definition<T> definition, Qualifier qualifier, bool override]) {
    var beanDefinition =
        BeanDefinition<T>.createScoped(qualifier, this.qualifier, definition);
    declareDefinition(
        beanDefinition, Options(isCreatedAtStart: false, override: override));
    if (!definitions.contains(beanDefinition)) {
      definitions.add(beanDefinition);
    } else {
      // throw DefinitionOverrideException(
      //     "Can't add definition $beanDefinition for scope ${this.qualifier} as it already exists");
    }
    beanDefinition.onClose((bloc) => bloc.dispose());
    return beanDefinition;
  }
}
