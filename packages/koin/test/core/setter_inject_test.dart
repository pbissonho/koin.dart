import 'package:koin/koin.dart';

class B {}

class C {}

class D {}

class G {}

class A extends KoinComponent {
  B b;
  C c;
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



class AInj extends KoinComponent {
  Lazy<B> b;
  Lazy<C> c;

  AInj() {
    b = inject();
    c = inject();
  }
}

void main() {
  
}