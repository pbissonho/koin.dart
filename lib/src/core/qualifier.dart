/// Help qualify a component
abstract class Qualifier {
  Qualifier(String s);
}

/// Give a String qualifier

Qualifier named(String name) => StringQualifier(name);

/// Give a Type based qualifier

Qualifier typed<T>(T type) => TypeQualifier(type);

class StringQualifier implements Qualifier {
  final String value;
  StringQualifier(this.value);

  String toString() {
    return value;
  }
}

class TypeQualifier<T> implements Qualifier {
  final T type;
  TypeQualifier(this.type);

  String toString() {
    return type.toString();
  }
}

class EnumQualifier<T> implements Qualifier {
  final T enumType;
  EnumQualifier(this.enumType);

  String toString() {
    return enumType.toString();
  }
}
