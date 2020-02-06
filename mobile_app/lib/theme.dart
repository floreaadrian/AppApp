import 'dart:ui';

import 'package:flutter/material.dart';

const tangerine = const Color(0xFFe37222);
const teal = const Color(0xFF07889b);
const powder = const Color(0xFF66b9bf);
const tan = const Color(0xFFeeaa7b);
Color grey = Colors.grey[100];
const double fontSizeBody = 16.0;

var lightTheme = ThemeData(
  brightness: Brightness.light,
  backgroundColor: grey,
  primaryColor: tangerine,
  accentColor: teal,
  cardColor: powder,
  splashColor: tan,
  appBarTheme: AppBarTheme(
    brightness: Brightness.light,
    color: powder,
  ),
  buttonColor: tangerine,
  textTheme: TextTheme(
      title: TextStyle(
        color: grey,
        fontFamily: 'Oswald',
        decorationStyle: TextDecorationStyle.solid,
      ),
      body1: TextStyle(
        color: grey,
        fontFamily: 'Oswald',
        fontSize: fontSizeBody,
        decorationStyle: TextDecorationStyle.solid,
      )),
  iconTheme: IconThemeData(
    color: Colors.black,
  ),
);
