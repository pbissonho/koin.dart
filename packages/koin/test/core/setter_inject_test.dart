import 'package:koin/koin.dart';
import 'package:koin/src/koin_component.dart';

class B {}

class C {}

class D {}

class G {}

class A extends KoinComponent {
  late B b;
  late C c;
}

class BofA {
  final A a;

  BofA(this.a);
}

class CofB {
  final BofA b;

  CofB(this.b);
}

class CofW {
  final G g;

  CofW(this.g);
}

void main() {}
