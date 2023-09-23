import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Color.fromARGB(255, 245, 245, 248),
    primary: Color.fromARGB(255, 223, 189, 20),
    onPrimary: Colors.black,
    primaryContainer: Color.fromARGB(252, 35, 37, 33),
    secondary: Color.fromARGB(255, 215, 219, 243),
    tertiary: Color.fromARGB(255, 0, 0, 0),
    shadow: Color.fromARGB(127, 0, 0, 0)
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
    tertiary:Color.fromARGB(255, 35, 36, 42) ,
    shadow: Color.fromARGB(127, 0, 0, 0)
  ),
);
