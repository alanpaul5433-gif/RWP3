import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ==================== Brand Colors ====================
  static const Color _primaryRed = Color(0xFFC41E24);
  static const Color _darkRed = Color(0xFF8B0000);
  static const Color _cream = Color(0xFFF5F2ED);
  static const Color _warmWhite = Color(0xFFFAF8F5);
  static const Color _charcoal = Color(0xFF1A1A1A);
  // ignore: unused_field
  static const Color _grey600 = Color(0xFF6B6B6B);
  static const Color _grey400 = Color(0xFF9E9E9E);
  static const Color _grey200 = Color(0xFFE8E5E0);
  static const Color _greenAccent = Color(0xFF2E7D32);

  static final TextTheme _textTheme = GoogleFonts.interTextTheme();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: _primaryRed,
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFFFE0E0),
          onPrimaryContainer: _darkRed,
          secondary: Color(0xFF1A1A1A),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFE8E5E0),
          onSecondaryContainer: Color(0xFF1A1A1A),
          surface: _warmWhite,
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: _grey200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: _grey200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: _primaryRed, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFBA1A1A)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFBA1A1A), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          labelStyle: TextStyle(color: _grey400, fontSize: 14),
          hintStyle: TextStyle(color: _grey400, fontSize: 14),
          prefixIconColor: _grey400,
          suffixIconColor: _grey400,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: _primaryRed,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: _charcoal,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            side: BorderSide(color: _grey200),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: _primaryRed,
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.white,
          surfaceTintColor: Colors.transparent,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: _charcoal,
          titleTextStyle: _textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: _charcoal,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: _primaryRed,
          unselectedItemColor: _grey400,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontSize: 12),
        ),
        dividerTheme: const DividerThemeData(
          space: 1,
          color: _grey200,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.white,
          selectedColor: _primaryRed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFFEF5350),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFF93000A),
          onPrimaryContainer: Color(0xFFFFDAD6),
          secondary: Color(0xFFE0E0E0),
          onSecondary: Color(0xFF1A1A1A),
          secondaryContainer: Color(0xFF3A3A3A),
          onSecondaryContainer: Color(0xFFE0E0E0),
          surface: Color(0xFF1A1A1A),
          onSurface: Color(0xFFE6E1E5),
          surfaceContainerHighest: Color(0xFF2B2B2F),
          error: Color(0xFFFFB4AB),
          onError: Color(0xFF690005),
          outline: Color(0xFF3A3A3A),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        textTheme: _textTheme.apply(
          bodyColor: const Color(0xFFE6E1E5),
          displayColor: const Color(0xFFE6E1E5),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2B2B2F),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFEF5350), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFEF5350),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            side: const BorderSide(color: Color(0xFF3A3A3A)),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: const Color(0xFF2B2B2F),
          surfaceTintColor: Colors.transparent,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFFE6E1E5),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1A1A1A),
          selectedItemColor: Color(0xFFEF5350),
          unselectedItemColor: Color(0xFF6B6B6B),
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        dividerTheme: const DividerThemeData(
          space: 1,
          color: Color(0xFF3A3A3A),
        ),
      );
}
