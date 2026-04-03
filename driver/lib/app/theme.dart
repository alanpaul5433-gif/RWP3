import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DriverTheme {
  DriverTheme._();

  static const Color _primaryRed = Color(0xFFC41E24);
  static const Color _cream = Color(0xFFF5F2ED);
  static const Color _charcoal = Color(0xFF1A1A1A);
  static const Color _grey200 = Color(0xFFE8E5E0);

  static final TextTheme _textTheme = GoogleFonts.interTextTheme();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: _primaryRed,
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFFFE0E0),
          onPrimaryContainer: Color(0xFF8B0000),
          secondary: Color(0xFF1A1A1A),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFE8E5E0),
          onSecondaryContainer: Color(0xFF1A1A1A),
          surface: Color(0xFFFAF8F5),
          onSurface: _charcoal,
          surfaceContainerHighest: _cream,
          error: Color(0xFFBA1A1A),
          onError: Color(0xFFFFFFFF),
          outline: _grey200,
        ),
        scaffoldBackgroundColor: _cream,
        textTheme: _textTheme,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: _grey200)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: _grey200)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: _primaryRed, width: 1.5)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: _primaryRed,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: _charcoal,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            side: BorderSide(color: _grey200),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.white,
          surfaceTintColor: Colors.transparent,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: _charcoal,
          titleTextStyle: _textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: _charcoal),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: _primaryRed,
          unselectedItemColor: Color(0xFF9E9E9E),
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
      );

  static ThemeData get dark {
    const darkSurface = Color(0xFF141416);
    const darkCard = Color(0xFF1E1E22);
    const darkOutline = Color(0xFF2E2E34);
    const textPrimary = Color(0xFFF0EFED);
    const textSecondary = Color(0xFF9A9A9E);
    const accentRed = Color(0xFFEF5350);

    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: accentRed,
        onPrimary: Color(0xFFFFFFFF),
        primaryContainer: Color(0xFF93000A),
        onPrimaryContainer: Color(0xFFFFDAD6),
        secondary: textSecondary,
        onSecondary: darkSurface,
        secondaryContainer: darkCard,
        onSecondaryContainer: textPrimary,
        surface: darkCard,
        onSurface: textPrimary,
        surfaceContainerHighest: darkCard,
        error: Color(0xFFFFB4AB),
        onError: Color(0xFF690005),
        outline: darkOutline,
      ),
      scaffoldBackgroundColor: darkSurface,
      textTheme: _textTheme.apply(bodyColor: textPrimary, displayColor: textPrimary),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: darkOutline)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: darkOutline)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: accentRed, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textSecondary),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accentRed,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          side: const BorderSide(color: darkOutline),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: darkCard,
        surfaceTintColor: Colors.transparent,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        titleTextStyle: _textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkCard,
        selectedItemColor: accentRed,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerTheme: const DividerThemeData(color: darkOutline),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? Colors.white : textSecondary),
        trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? accentRed : darkOutline),
      ),
    );
  }
}
