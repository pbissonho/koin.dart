import 'package:koin/koin.dart';

mixin Disposable {
  void dispose();
}

extension BlocModuleExtension on Module {
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
}

extension ScopeSetBlocExtension on ScopeSet {
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


