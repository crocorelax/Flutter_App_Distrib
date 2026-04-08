import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0xFF80B9C5);
  static const backgroundColor = Color(0xFF2B636E);
  static const inputFillColor = Color.fromARGB(255, 214, 224, 231);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundColor,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: inputFillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}
