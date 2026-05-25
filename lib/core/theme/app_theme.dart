import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color brandPrimary = Color(0xFF1C4291);

  static const String primaryFont = 'Inter';
  static const String secondaryFont = 'Poppins';

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: brandPrimary,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      fontFamily: primaryFont,
      scaffoldBackgroundColor: const Color(0xFFF8F7FF),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: brandPrimary,
        iconTheme: IconThemeData(color: brandPrimary),
        titleTextStyle: TextStyle(
          fontFamily: secondaryFont,
          color: brandPrimary,
          fontWeight: FontWeight.w800,
          fontSize: 22,
          letterSpacing: -0.5,
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
            fontFamily: secondaryFont,
            fontWeight: FontWeight.bold,
            fontSize: 20),
        labelSmall: TextStyle(
            fontFamily: primaryFont,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            fontSize: 11),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Colors.white,
        elevation: 16,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
      ),
    );
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: brandPrimary,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      fontFamily: primaryFont,
      scaffoldBackgroundColor: const Color(0xFF0F0E17),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Color(0xFF0F0E17),
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          fontFamily: secondaryFont,
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 22,
          letterSpacing: -0.5,
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
            fontFamily: secondaryFont,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white),
        labelSmall: TextStyle(
            fontFamily: primaryFont,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            fontSize: 11),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Color(0xFF1A1A2E),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
