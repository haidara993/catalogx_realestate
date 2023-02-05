import 'package:catalog/themes/my_input_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class Themes {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.tajawal().fontFamily,
    textTheme: TextTheme(
      bodyText1: TextStyle(fontSize: 17.0),
      bodyText2: TextStyle(fontSize: 16.0),
      button: TextStyle(fontSize: 16.0),
    ),
    colorScheme: ColorScheme.light().copyWith(
      primary: HexColor("#00324b"),
      secondary: Colors.white60,
    ),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: Colors.white60),
    inputDecorationTheme: MyInputTheme().theme(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          // minimumSize: Size.fromWidth(Get.width * .9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          primary: Get.theme.primaryColor,
          // fixedSize: Size(Get.width * .9, 50),
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          )),
    ),
  );
  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(),
  );
}
