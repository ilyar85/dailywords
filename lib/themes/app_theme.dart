import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: const Color(0xFF003AFF),
  scaffoldBackgroundColor: const Color(0xFF000000),
  cardColor: const Color(0xFF151515),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontFamily: 'K_GothamPro', color: Color(0xFFEBEBEB)),  // замена для headline1
    bodyLarge: TextStyle(fontFamily: 'K_GothamPro', color: Color(0xFFFFFFFF)),     // замена для bodyText1
    bodyMedium: TextStyle(fontFamily: 'K_GothamPro', color: Color(0xFFFFFFFF)),     // замена для bodyText1
  ),
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
  cardTheme: CardTheme(
    color: const Color(0xFF151515),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    background: const Color(0xFF000000),  // замена для backgroundColor
  ),
);
