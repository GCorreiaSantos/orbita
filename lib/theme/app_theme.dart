import 'package:flutter/material.dart';

class AppTheme {
  static  Color primary = Color(0xFF7561D8);
  static const Color background = Color(0xFFF8F7FC);
  static const Color text = Color(0xFF302D43);
  static const Color muted = Color(0xFF858197);
  static const Color border = Color(0xFFE8E3F2);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ),
      fontFamily: 'Roboto',
    );
  }
}