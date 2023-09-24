import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    // background: Color.fromARGB(255, 245, 246, 248),
    // primary: Color.fromARGB(255, 27, 42, 72),
    // onPrimary: Color.fromARGB(255, 0, 0, 0),
    // primaryContainer: Color.fromARGB(173, 255, 255, 255),
    // onPrimaryContainer: Color.fromARGB(35, 60, 79, 250),
    // secondary: Color.fromARGB(255, 236, 180, 26),
    // secondaryContainer: Color.fromARGB(40, 255, 255, 255),
    // tertiary: Color.fromARGB(255, 32, 30, 37),
    // shadow: Color.fromARGB(127, 0, 0, 0),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
      background: Color.fromARGB(255, 15, 15, 16),
      primary: Color.fromARGB(255, 60, 80, 250),
      onPrimary: Colors.white,
      primaryContainer: Color.fromARGB(173, 255, 255, 255),
      onPrimaryContainer: Color.fromARGB(35, 60, 79, 250),
      secondary: Color.fromARGB(255, 27, 28, 34),
      secondaryContainer: Color.fromARGB(40, 255, 255, 255),
      tertiary: Color.fromARGB(255, 35, 36, 42),
      shadow: Color.fromARGB(127, 0, 0, 0)),
);
