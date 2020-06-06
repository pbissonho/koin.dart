import 'package:koin/koin.dart';

extension KoinComponentExtensionMixin on KoinComponentMixin {
  T bloc<T>([Qualifier qualifier, DefinitionParameters parameters]) {
    return get<T>(qualifier, parameters);
  }
}

extension KoinComponentExtension on KoinComponent {
  T bloc<T>([Qualifier qualifier, DefinitionParameters parameters]) {
    return get<T>(qualifier, parameters);
  }
}

abstract class Disposable {
  void dispose();
}

extension BlocModuleExtension on Module {
  BeanDefinition<T> bloc<T extends Disposable>(
    DefinitionFunction<T> definition, {
    Qualifier qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    var beanDefinition = single<T>(definition,
        qualifier: qualifier,
        createdAtStart: createdAtStart,
        override: override);

    beanDefinition.onClose((bloc) => bloc.dispose());
    return beanDefinition;
  }
}

extension ScopeSetBlocExtension on ScopeDSL {
  BeanDefinition<T> scopedBloc<T extends Disposable>(
    DefinitionFunction<T> definition, {
    Qualifier qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    var beanDefinition =
        scoped<T>(definition, qualifier: qualifier, override: override);

    beanDefinition.onClose((bloc) => bloc.dispose());
    return beanDefinition;
  }
}
