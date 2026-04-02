import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminTheme {
  AdminTheme._();

  static final TextTheme _textTheme = GoogleFonts.interTextTheme();

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
        cardTheme: CardThemeData(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: const Color(0xFFFFFFFF),
          surfaceTintColor: Colors.transparent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Color(0xFFD32F2F), width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(120, 48),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
        navigationRailTheme: const NavigationRailThemeData(
          backgroundColor: Color(0xFFF5F5F5),
          selectedIconTheme: IconThemeData(color: Color(0xFFD32F2F)),
          selectedLabelTextStyle: TextStyle(
            color: Color(0xFFD32F2F),
            fontWeight: FontWeight.w600,
          ),
          unselectedIconTheme: IconThemeData(color: Color(0xFF757575)),
        ),
        dataTableTheme: const DataTableThemeData(
          headingTextStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1C1B1F),
          ),
        ),
      );
}
