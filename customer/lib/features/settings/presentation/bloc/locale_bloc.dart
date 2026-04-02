import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'locale_event.dart';
part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(const LocaleState(Locale('en'))) {
    on<LocaleChanged>(_onChanged);
  }

  static const supportedLocales = [
    Locale('en'),
    Locale('ar'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
  ];

  static const localeNames = {
    'en': 'English',
    'ar': 'العربية',
    'es': 'Español',
    'fr': 'Français',
    'hi': 'हिन्दी',
  };

  void _onChanged(LocaleChanged event, Emitter<LocaleState> emit) {
    // In production: persist to SharedPreferences + load translations from Firestore
    emit(LocaleState(event.locale));
  }
}
