import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // Основные цвета
      primaryColor: Colors.grey[300], // Светло-серый основной
      scaffoldBackgroundColor: Colors.grey[300], // Светло-серый фон

      // Цвета AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[300], // Светло-серый AppBar
        elevation: 0, // Убираем тень для плоского дизайна
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Цвета плавающей кнопки действия
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black87,
      ),

      // Цвета инпутов
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey[600]!),
        ),
      ),

      // Остальные цвета оставляем стандартными
      colorScheme: ColorScheme.light(
        primary: const Color.fromARGB(255, 222, 222, 222),
        onPrimary: Colors.white,
        secondary: Colors.green.withValues(alpha: 0.2),
        onSecondary: Colors.green,
        error: Colors.red.withValues(alpha: 0.1),
        onError: Colors.red,
        onPrimaryContainer: Colors.blueAccent,
      ),

      // Прочие настройки
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  // Опционально: можно добавить темную тему
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      // Настройки для темной темы, если понадобится
      cardColor: Colors.grey[800],
    );
  }
}
