
import 'package:koin/koin.dart';

abstract class Heater {
  void on();
  void off();
  bool isHot();
}

class ElectricHeater implements Heater {
  bool heating = false;

  void on() {
    heating = true;
  }

  void off() {
    heating = false;
  }

  bool isHot() => heating;
}

abstract class Pump {
  void pump();
}

class Thermosiphon implements Pump {
  final Heater heater;

  Thermosiphon(this.heater);

  void pump() {
    if (heater.isHot()) {
      print("=> => pumping => =>");
    }
  }
}

class CoffeeMaker {
  final Heater heater;
  final Pump pump;

  CoffeeMaker(this.heater, this.pump);

  void brew() {
    heater.on();
    pump.pump();
    print(" [_]P coffee! [_]P ");
    heater.off();
  }
}

class CoffeeApp {
  final CoffeeMaker coffeeMaker;

  CoffeeApp(this.coffeeMaker);
}

var coffeeAppModule = Module()
  ..single((s) => CoffeeMaker(s.get(), s.get()))
  ..single<Heater>((s) => ElectricHeater())
  ..single<Pump>((s) => Thermosiphon(s.get()));

void main() {
  var koin = startKoin((app) {
    app.module(coffeeAppModule);
  }).koin;

  var coffeeShop = CoffeeApp(koin.get());

  coffeeShop.coffeeMaker.brew();

  stopKoin();
}