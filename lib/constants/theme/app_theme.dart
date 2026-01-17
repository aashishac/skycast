import 'package:flutter/material.dart';

class AppTheme {
  // Shared brand colors
  static const Color primaryDark = Color(0xFF070D2A); // deep navy
  static const Color accentBlue = Color(0xFF333162); // secondary blue
  static const Color cardDark = Color(0xFF0A174D); // dark card background
  static const Color highlight = Color(0xFF4FC3F7); // cyan accent

  // Light palette
  static const Color primaryLight = Color(0xFFFFFFFF); // white
  static const Color scaffoldLight = Color(0xFFF5F5F5); // soft grey background
  static const Color cardLight = Color(0xFFFFFFFF); // white cards
  static const Color textDark = Color(0xFF1A1A1A); // dark text

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: accentBlue,
      scaffoldBackgroundColor: Color(0xFFE8EEFF),
      cardColor: Color(0xFFFFFFFF),
      useMaterial3: true,

      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFE8EEFF),
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFE8EEFF),
        foregroundColor: Colors.white,
        shape: CircleBorder(),
      ),

      bottomAppBarTheme: const BottomAppBarThemeData(
        color: Colors.white,
        elevation: 4,
        shape: CircularNotchedRectangle(),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        bodyMedium: TextStyle(fontSize: 16, color: Colors.black54),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
      ),

      // cardTheme: CardTheme(
      //   color: cardLight,
      //   elevation: 4,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      // ),
      iconTheme: const IconThemeData(color: Colors.black87),
      dividerColor: Colors.black12,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: accentBlue,
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: accentBlue,
      scaffoldBackgroundColor: const Color.fromARGB(255, 1, 3, 12),
      cardColor: Color(0xFF333162),
      useMaterial3: true,

      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 1, 3, 12),
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentBlue,
        foregroundColor: Color.fromARGB(255, 27, 20, 20),
        shape: CircleBorder(),
      ),

      bottomAppBarTheme: const BottomAppBarThemeData(
        color: Color(0xFF121212),
        elevation: 8,
        shape: CircularNotchedRectangle(),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      // cardTheme: CardTheme(
      //   color: cardDark,
      //   elevation: 4,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      // ),
      iconTheme: const IconThemeData(color: Colors.white),
      dividerColor: Colors.white24,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: highlight,
      ),
    );
  }
}
