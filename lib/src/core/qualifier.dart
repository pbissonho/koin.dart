import 'package:equatable/equatable.dart';

/// Help qualify a component
abstract class Qualifier {
  Qualifier(String s);
}

/// Give a String qualifier

Qualifier named(String name) => StringQualifier(name);

/// Give a Type based qualifier

Qualifier typed<T>(T type) => TypeQualifier(type);

class StringQualifier extends Equatable implements Qualifier {
  final String value;
  StringQualifier(this.value);

  String toString() {
    return value;
  }

  @override
  List<Object> get props => [value];
}

class TypeQualifier<T> extends Equatable implements Qualifier {
  final T type;
  TypeQualifier(this.type);

  String toString() {
    return type.toString();
  }

  @override
  List<Object> get props => [type];
}
