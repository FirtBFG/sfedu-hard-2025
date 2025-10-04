import 'package:flutter/material.dart';

class AppTheme {
  /// Светлая тема с акцентом на светло-серый фон
  static ThemeData get lightTheme {
    return ThemeData(
      // Устанавливаем яркость light
      brightness: Brightness.light,

      // Основные цвета
      primaryColor: Colors.grey[300], // Светло-серый основной
      scaffoldBackgroundColor: Colors.grey[300], // Светло-серый фон

      // Цвета AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[300], // Светло-серый AppBar
        elevation: 0,
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

      // Прочие настройки
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // Схема цветов (Light)
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF6200EE), // Яркий акцент
        onPrimary: Colors.white,
        secondary: const Color.fromARGB(255, 121, 252, 162), // Вторичный акцент
        onSecondary: Colors.black,
        surface: Colors.white,
        error: Colors.red,
        onError: Colors.white,
      ),
    );
  }

  // --------------------------------------------------------------------------

  /// Крутая Темная тема (Deep Dark Theme)
  static ThemeData get darkTheme {
    // Темный фон (практически черный) для комфорта глаз
    const Color darkBackground = Color(0xFF121212);
    // Цвет поверхности (карточки, панели) - немного светлее фона
    const Color darkSurface = Color(0xFF1F1F1F);
    // Основной акцентный цвет (сиреневый)
    const Color primaryColor = Color(0xFFBB86FC);
    // Вторичный акцентный цвет (бирюзовый/зеленый) - отлично для графиков
    const Color secondaryColor = Color.fromARGB(255, 52, 254, 113);

    return ThemeData(
      // Устанавливаем яркость dark
      brightness: Brightness.dark,

      // Основные цвета
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBackground, // Глубокий темный фон

      // Цвета AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface, // Фон AppBar чуть светлее фона
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Цвета карточек (для элементов интерфейса, например, статистики)
      cardColor: darkSurface,

      // Цвета плавающей кнопки действия (используем акцентный цвет)
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.black,
      ),

      // Цвета кнопок
      buttonTheme: const ButtonThemeData(
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.primary,
      ),

      // Цвета инпутов
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface, // Фон инпута соответствует поверхности
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: TextStyle(color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide:
              const BorderSide(color: primaryColor), // Фокус - акцентный цвет
        ),
      ),

      // Схема цветов (Dark)
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        onPrimary:
            Color.fromARGB(255, 91, 162, 244), // Текст на акцентном цвете
        secondary: secondaryColor,
        onSecondary: Colors.black,
        surface: darkSurface,
        error: Color(0xFFCF6679), // Красный для ошибок
        onError: Colors.black,
      ),

      // Прочие настройки
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
