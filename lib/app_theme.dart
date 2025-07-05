import 'package:flutter/material.dart';

import 'constants/my_colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: MyColors.myBlue,
    scaffoldBackgroundColor: MyColors.myWhite,
    colorScheme: ColorScheme.light(
      primary: MyColors.myBlue,
      secondary: Color(0xFFE0E0E0),
      surface: MyColors.myGrey2,
    ),
    appBarTheme: AppBarTheme(color: MyColors.myGrey2),
    iconTheme: IconThemeData(color: MyColors.myBlack50),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: MyColors.myBlack50),
      bodyMedium: TextStyle(color: MyColors.myBlack50),
    ),
    bottomAppBarTheme: BottomAppBarTheme(color: MyColors.myGrey2),
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      fillColor: MyColors.myGrey2,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(65)),
      hintStyle: TextStyle(color: MyColors.myGrey2),
      labelStyle: TextStyle(color: MyColors.myWhite),
      prefixIconColor: MyColors.myBlue,
    ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: MyColors.myBlue,
    scaffoldBackgroundColor: MyColors.myBlack,
    colorScheme: ColorScheme.dark(
      primary: MyColors.myBlue,
      secondary: Color(0xFF2C2C2C),
      surface: MyColors.myBlack50,
    ),
    appBarTheme: AppBarTheme(color: MyColors.myBlack50),
    iconTheme: IconThemeData(color: MyColors.myGrey2),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: MyColors.myWhite),
      bodyMedium: TextStyle(color: MyColors.myGrey),
    ),
    bottomAppBarTheme: BottomAppBarTheme(color: MyColors.myBlack50),
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      fillColor: MyColors.myBlack50,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(125)),
      hintStyle: TextStyle(color: MyColors.myBlack50),
      labelStyle: TextStyle(color: MyColors.myBlack50),
      prefixIconColor: MyColors.myBlue,
    ),
  );
}
