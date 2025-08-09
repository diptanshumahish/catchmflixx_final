import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class CatchMFLixxTheme {
  static final theme = ThemeData(
    // Ensure Material text uses Karla everywhere
    textTheme: GoogleFonts.karlaTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ),
    // Ensure Cupertino widgets used within Material tree use Karla too
    cupertinoOverrideTheme: CupertinoThemeData(
      textTheme: CupertinoTextThemeData(
        textStyle: GoogleFonts.karla(),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
      },
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF00F5C8), // Brand: bold greenish-cyan (unique)
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}

abstract class CatchMFLixxThemeIOS {
  static final theme = CupertinoThemeData(
    primaryColor: const Color(0xFF00F5C8),
    primaryContrastingColor: CupertinoColors.black,
    textTheme: CupertinoTextThemeData(
      primaryColor: CupertinoColors.white,
      textStyle: GoogleFonts.karla(),
    ),
    barBackgroundColor: CupertinoColors.black,
    scaffoldBackgroundColor: CupertinoColors.black,
  );
}
