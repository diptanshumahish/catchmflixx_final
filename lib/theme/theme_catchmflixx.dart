import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class CatchMFLixxTheme {
  static final theme = ThemeData(
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
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5AB5FF)),
    useMaterial3: true,
    fontFamily: "Kollektif",
  );
}

abstract class CatchMFLixxThemeIOS {
  static const theme = CupertinoThemeData(
    primaryColor: CupertinoColors.activeBlue,
    primaryContrastingColor: CupertinoColors.white,
    textTheme: CupertinoTextThemeData(
      primaryColor: CupertinoColors.white,
      textStyle: TextStyle(
        fontFamily: "Kollektif",
      ),
    ),
    barBackgroundColor: CupertinoColors.systemBackground,
    scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
  );
}
