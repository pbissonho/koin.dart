import 'dart:core';
import 'package:koin/src/error/exceptions.dart';

class DefinitionParameters {
  final List<Object> _values;

  static final int maxParams = 5;

  int index = 0;

  DefinitionParameters(this._values);

  Object elementAt(int i) {
    if (this._values.length > i) {
      return this._values[i];
    } else {
      throw NoParameterFoundException(
          "Can't get parameter value $i from $this");
    }
  }

  Object component1() => elementAt(0);
  Object component2() => elementAt(1);
  Object component3() => elementAt(2);
  Object component4() => elementAt(3);
  Object component5() => elementAt(4);

  Object get() {
    var object = elementAt(index);
    index++;
    return object;
  }

  int size() => _values.length;

  bool isEmpty() => size() == 0;

  bool isNotEmpty() => !isEmpty();

  Object first() => elementAt(0);

  factory DefinitionParameters.emptyParametersHolder() {
    return DefinitionParameters(<Object>[]);
  }

  factory DefinitionParameters.parametersOf(List<Object> parameters) {
    if (parameters.length <= maxParams) {
      return DefinitionParameters(parameters);
    } else {
      String message =
          "Can't build DefinitionParameters for more than 5 arguments";

      throw IllegalStateException(message);
    }
  }
}

DefinitionParameters parametersOf(List<Object> parameters) {
  return DefinitionParameters.parametersOf(parameters);
}
