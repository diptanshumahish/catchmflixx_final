import 'package:flutter/material.dart';

abstract class CFGradient {
  static const topToBottomGradient = LinearGradient(
      colors: [Colors.transparent, Colors.black],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);
}
