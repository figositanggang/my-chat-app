import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color darkBlue = Color.fromARGB(255, 4, 14, 21);
Color blue = Color.fromARGB(255, 13, 61, 166);
Color lightBlue = Color.fromARGB(255, 55, 165, 255);
Color scaffoldBackgroundColor = Color.fromARGB(255, 6, 22, 36);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: scaffoldBackgroundColor,
  splashColor: Colors.transparent,
  highlightColor: lightBlue.withOpacity(.1),

  // App Bar Theme
  appBarTheme: AppBarTheme(
    backgroundColor: lightBlue.withOpacity(.1),
    foregroundColor: Colors.white,
  ),

  // Dialog Theme
  dialogTheme: DialogTheme(
    backgroundColor: darkBlue,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
  ),

  // Elevated Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: blue,
      foregroundColor: Colors.white,
      disabledBackgroundColor: blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),
  ),

  // Floating Action Button Theme
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: blue,
    foregroundColor: Colors.white,
    shape: CircleBorder(),
  ),

  // Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(
      color: Colors.white.withOpacity(.5),
      fontSize: 13,
      letterSpacing: 2,
    ),
    suffixIconColor: lightBlue,
    contentPadding: EdgeInsets.all(20),
    border: OutlineInputBorder(borderRadius: BorderRadius.zero),
  ),

  // ListTile Theme
  listTileTheme: ListTileThemeData(
    titleTextStyle: GoogleFonts.poppins().apply(color: Colors.white),
    subtitleTextStyle: GoogleFonts.poppins().apply(color: Colors.grey),
    selectedColor: Colors.red,
    leadingAndTrailingTextStyle:
        GoogleFonts.poppins().apply(color: Colors.grey),
  ),

  // Text Theme
  textTheme: GoogleFonts.poppinsTextTheme().apply(
    bodyColor: Colors.white,
    displayColor: Colors.grey,
  ),

  // Text Button Theme
  textButtonTheme: TextButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: lightBlue,
    ),
  ),
);
