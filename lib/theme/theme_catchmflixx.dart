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
        },
      ),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5AB5FF)),
      useMaterial3: true,
      fontFamily: "Kollektif");
}
