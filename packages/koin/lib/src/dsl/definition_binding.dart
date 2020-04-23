import '../core/definition/bean_definition.dart';

///
/// BeanDefinition DSL specific functions
///
/// @author Arnaud Giuliani
///

///
/// Add a compatible type to match for definition
/// @param clazz
///
///

extension<T> on BeanDefinition<T> {
  BeanDefinition bind(Type type) {
    var newTypes = List.from([type]);
    newTypes.addAll(secondaryTypes);

    var copyT = copy(secondaryTypes: newTypes);
    scopeDefinition.remove(this);
    scopeDefinition.save(copyT);
    return copyT;
  }

  BeanDefinition binds(List<Type> types) {
    types.addAll(secondaryTypes);

    var copyT = copy(secondaryTypes: types);
    scopeDefinition.remove(this);
    scopeDefinition.save(copyT);
    return copyT;
  }

  BeanDefinition<T> onClose(OnCloseCallback<T> onCloseCallback) {
    var copyT = copy(callbacks: Callbacks(onCloseCallback: onCloseCallback));
    scopeDefinition.remove(this);
    scopeDefinition.save(copyT);
    return copyT;
  }
}
