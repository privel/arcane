import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData light = ThemeData.light().copyWith(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black, fontFamily: "Inter"),
      displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
      labelLarge: TextStyle(fontSize: 14, color: Colors.white),
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor:
          const WidgetStatePropertyAll<Color>(Colors.white), // цвет галочки
      fillColor:
          WidgetStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFFb31217); // красная заливка, если выбран
        }
        return Colors.white; // фон, если не выбран
      }),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(
              width: 1.0,
              color: Colors.black12,
            ),
          ),
        ),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
    ),
    
    colorScheme: const ColorScheme.light(
      primary: Colors.black,
      secondary: Colors.greenAccent,
      background: Colors.white,
      onPrimary: Colors.black,
    ),
  );

  static final ThemeData dark = ThemeData.dark().copyWith(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white, fontFamily: "Inter"),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      secondary: Colors.tealAccent,
      background: Colors.black,
      onPrimary: Colors.white,
    ),
  );
}
