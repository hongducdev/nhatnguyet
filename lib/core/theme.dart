import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primaryGreen = Color(0xFF7FA36B);
  static const secondaryGreen = Color(0xFFB7C4A8);
  static const backgroundBeige = Color(0xFFE7DFD1);
  static const textDark = Color(0xFF2D2F33);

  static TextTheme _getTextTheme() {
    final base = GoogleFonts.googleSansFlexTextTheme();
    return base.apply(
      bodyColor: textDark,
      displayColor: textDark,
    );
  }

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundBeige,
      textTheme: _getTextTheme(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        secondary: secondaryGreen,
        surface: backgroundBeige,
        onPrimary: Colors.white,
        onSecondary: textDark,
        onSurface: textDark,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.googleSansFlexTextTheme(
        ThemeData.dark().textTheme,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
  }
}
