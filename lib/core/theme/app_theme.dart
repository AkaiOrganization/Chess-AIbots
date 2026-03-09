import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF1C1A17),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1C1A17),
        elevation: 0,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFD6B37A),
        brightness: Brightness.dark,
      ),
    );
  }
}