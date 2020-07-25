import 'package:bloc/bloc.dart';
import 'package:koin/koin.dart';
import 'package:koin_bloc/koin_bloc.dart';

// Create your Cubit
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
}

// Your scope class
class MyScope {}

// Define a module with your cubit
var cubitModule = Module()
  // Define a single cubit.
  // Single Cubit will be closed when the global context of the koin is closed.
  ..cubit((s) => CounterCubit())
  // Define a scoped cubit for MyScopeWidget.
  // Scoped Cubit will be closed when the scope instance is closed,
  //that is, when MyScopeWidget is removed from the widget tree
  ..scope<MyScope>((scope) {
    scope.scopedCubit<CounterCubit>((scope) => CounterCubit());
  });
