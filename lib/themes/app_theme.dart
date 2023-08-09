import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: const Color(0xFF003AFF),
  scaffoldBackgroundColor: const Color(0xFF000000),
  cardColor: const Color(0xFF151515),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontFamily: 'K_GothamPro', color: Color(0xFFEBEBEB), fontSize: 23),  // замена для headline1
    bodyLarge: TextStyle(fontFamily: 'K_GothamPro', color: Color(0xFFFFFFFF),fontSize: 20),     // замена для bodyText1
    bodyMedium: TextStyle(fontFamily: 'K_GothamPro', color: Color(0xFFFFFFFF),fontSize: 15),     // замена для bodyText1
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
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.black),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      side: MaterialStateProperty.all(BorderSide(color: Color(0xFF6F6F6F))),
      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 40, vertical: 16)), // делаем кнопку шире
    ),
  ),  
);
