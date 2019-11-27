import 'package:koin/koin.dart';
import 'package:koin_and_bloc/counter_bloc.dart';

import 'counter_page.dart';

var loginScope = named("LoginScope");

class Teste {
  final Tuca tuca;
  Teste(this.tuca);
}

class Teteca {
  final Tuca tuca;
  Teteca(this.tuca);
}

class Tuca {}

var appModule = Module()
  ..single<Teteca>((s, p) => Teteca(s.get<Tuca>()))
      .onClose((bloc) => bloc.close())
  ..single<CounterBloc>((s, p) => CounterBloc()).onClose((bloc) => bloc.close())
  ..single<CounterBloc>((s, p) => CounterBloc(), qualifier: named("Counter2"))
  ..factory((s, p) => Tuca())
  ..factory<Teste>((s, p) => Teste(p.component1()))
  ..scope(named<CounterScopePage>(), (scope) {
    scope
      ..scoped<CounterBloc>((s, p) => CounterBloc())
          .onClose((bloc) => bloc.close())
      ..scoped<Teste>((s, p) => Teste(s.get<Tuca>()));
  });

var otherModule = Module()
  ..single<Teteca>((s, p) => Teteca(s.get<Tuca>()), override: true)
      .onClose((bloc) => bloc.close());
