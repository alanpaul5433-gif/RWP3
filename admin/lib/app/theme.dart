import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminTheme {
  AdminTheme._();

  static const Color _primaryRed = Color(0xFFC41E24);
  static const Color _cream = Color(0xFFF0EDE8);
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
          surface: Color(0xFFFFFFFF),
          onSurface: _charcoal,
          surfaceContainerHighest: _cream,
          error: Color(0xFFBA1A1A),
          onError: Color(0xFFFFFFFF),
          outline: _grey200,
        ),
        scaffoldBackgroundColor: _cream,
        textTheme: _textTheme,
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
          surfaceTintColor: Colors.transparent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _grey200)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _grey200)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primaryRed, width: 1.5)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: _primaryRed,
            foregroundColor: Colors.white,
            minimumSize: const Size(120, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ),
        navigationRailTheme: NavigationRailThemeData(
          backgroundColor: Colors.white,
          selectedIconTheme: const IconThemeData(color: _primaryRed),
          unselectedIconTheme: const IconThemeData(color: Color(0xFF9E9E9E)),
          selectedLabelTextStyle: const TextStyle(color: _primaryRed, fontWeight: FontWeight.w700, fontSize: 12),
          unselectedLabelTextStyle: TextStyle(color: const Color(0xFF9E9E9E), fontSize: 12),
          indicatorColor: _primaryRed.withValues(alpha: 0.08),
        ),
        dataTableTheme: DataTableThemeData(
          headingTextStyle: TextStyle(fontWeight: FontWeight.w600, color: _charcoal.withValues(alpha: 0.5), fontSize: 12),
          dataTextStyle: const TextStyle(fontSize: 13),
          headingRowColor: WidgetStatePropertyAll(_cream),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        ),
        dividerTheme: const DividerThemeData(space: 1, color: _grey200),
      );
}
