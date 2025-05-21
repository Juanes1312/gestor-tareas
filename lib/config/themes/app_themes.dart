import 'package:flutter/material.dart';

class AppThemes {
  static const Color primary = Colors.green;

  static final ThemeData lighTheme = ThemeData.light().copyWith(
    primaryColor: primary,

    // Color del AppBar
    appBarTheme: const AppBarTheme(
      color: Colors.purple,
      elevation: 5,
    ),

    // Color de loo TextButton
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.purple,
      ),
    ),

    // Color del FloatingActionButton
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.purple,
      elevation: 5,
    ),

    // Tema del ElevatedButton
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 5,
      ),
    ),

    // Temas para los campos de texto y dropdownformfield
    inputDecorationTheme: InputDecorationTheme(
      // paddin o margen interno
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 2,
      ),
      // formato del label
      floatingLabelStyle: const TextStyle(color: primary),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: primary),
        borderRadius: BorderRadius.circular(10),
      ),
      // formato de las cajas de texto con el foco
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.purple, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),

      // Para todos los demás, este será el border
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),

    // formato de los Card
    cardTheme: const CardTheme(
      color: Color.fromARGB(255, 240, 237, 237),
      elevation: 5,
    ),
  );
}
