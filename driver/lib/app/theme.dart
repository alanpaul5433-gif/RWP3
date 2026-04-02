import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DriverTheme {
  DriverTheme._();

  static final TextTheme _textTheme = GoogleFonts.interTextTheme();

  // Driver app uses same color scheme but with a slightly different accent
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFD32F2F),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFFFCDD2),
          onPrimaryContainer: Color(0xFFB71C1C),
          secondary: Color(0xFF1976D2),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFBBDEFB),
          onSecondaryContainer: Color(0xFF0D47A1),
          surface: Color(0xFFFFFFFF),
          onSurface: Color(0xFF1C1B1F),
          surfaceContainerHighest: Color(0xFFF5F5F5),
          error: Color(0xFFBA1A1A),
          onError: Color(0xFFFFFFFF),
          outline: Color(0xFFE0E0E0),
        ),
        textTheme: _textTheme,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1.5)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          surfaceTintColor: Colors.transparent,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          titleTextStyle: _textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF1C1B1F)),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFFEF5350),
          onPrimary: Color(0xFF1C1B1F),
          primaryContainer: Color(0xFFB71C1C),
          onPrimaryContainer: Color(0xFFFFCDD2),
          secondary: Color(0xFF42A5F5),
          onSecondary: Color(0xFF1C1B1F),
          secondaryContainer: Color(0xFF0D47A1),
          onSecondaryContainer: Color(0xFFBBDEFB),
          surface: Color(0xFF1C1B1F),
          onSurface: Color(0xFFE6E1E5),
          surfaceContainerHighest: Color(0xFF2B2B2F),
          error: Color(0xFFFFB4AB),
          onError: Color(0xFF690005),
          outline: Color(0xFF424242),
        ),
        textTheme: _textTheme.apply(bodyColor: const Color(0xFFE6E1E5), displayColor: const Color(0xFFE6E1E5)),
        scaffoldBackgroundColor: const Color(0xFF1C1B1F),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: const Color(0xFF2B2B2F),
          surfaceTintColor: Colors.transparent,
        ),
      );
}
