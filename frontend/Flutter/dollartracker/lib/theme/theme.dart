import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Color.fromARGB(255, 248, 247, 240),
    onBackground: Colors.black,
    primary: Color.fromARGB(255, 27, 42, 72),
    onPrimary: Colors.white,
    primaryContainer: Color.fromARGB(173, 0, 0, 0),
    onPrimaryContainer: Color.fromARGB(173, 255, 255, 255),
    secondary: Color.fromARGB(255, 236, 180, 26),
    onSecondary: Colors.black,
    secondaryContainer: Color.fromARGB(50, 0, 0, 0),
    onSecondaryContainer: Color.fromARGB(35, 27, 42, 72),
    tertiary: Color.fromARGB(255, 35, 36, 42),
    onTertiary: Colors.white,
    outline: Color.fromARGB(40, 255, 255, 255),
    shadow: Color.fromARGB(70, 0, 0, 0),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Color.fromARGB(255, 15, 15, 16),
    onBackground: Colors.white,
    primary: Color.fromARGB(255, 60, 80, 250),
    onPrimary: Colors.white,
    primaryContainer: Color.fromARGB(173, 255, 255, 255),
    onPrimaryContainer: Color.fromARGB(173, 255, 255, 255),
    secondary: Color.fromARGB(255, 27, 28, 34),
    onSecondary: Colors.white,
    secondaryContainer: Color.fromARGB(50, 255, 255, 255),
    onSecondaryContainer: Color.fromARGB(60, 60, 79, 250),
    tertiary: Color.fromARGB(255, 35, 36, 42),
    onTertiary: Colors.white,
    outline: Color.fromARGB(40, 255, 255, 255),
    shadow: Color.fromARGB(140, 0, 0, 0),
  ),
);
