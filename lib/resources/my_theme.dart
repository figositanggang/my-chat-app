import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color darkBlue = Color.fromARGB(255, 12, 18, 23);
Color blue = Color.fromARGB(255, 8, 106, 163);
Color lightBlue = Color.fromARGB(255, 0, 140, 255);
Color scaffoldBackgroundColor = Color.fromARGB(255, 9, 15, 19);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: scaffoldBackgroundColor,
  splashColor: Colors.transparent,
  highlightColor: lightBlue.withOpacity(.1),
  brightness: Brightness.dark,

  // App Bar Theme
  appBarTheme: AppBarTheme(
    backgroundColor: blue.withOpacity(.1),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: Colors.white),
      ),
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
