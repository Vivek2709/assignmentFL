import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFFFDF5E6),
    primaryColor: const Color(0xFFF0BB78),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF543A14),
      titleTextStyle: TextStyle(
        color: Color(0xFFFDF5E6),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF543A14),
      selectedItemColor: Color(0xFFF0BB78),
      unselectedItemColor: Color(0xFFFDF5E6),
      showUnselectedLabels: true,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color(0xFF131010), fontSize: 16),
      bodySmall: TextStyle(color: Color(0xFF543A14), fontSize: 14),
    ),
  );
}
