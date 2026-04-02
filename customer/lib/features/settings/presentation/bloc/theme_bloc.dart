import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(ThemeMode.system)) {
    on<ThemeChanged>(_onChanged);
  }

  void _onChanged(ThemeChanged event, Emitter<ThemeState> emit) {
    // In production: persist to SharedPreferences
    emit(ThemeState(event.themeMode));
  }
}
