import 'dart:io';

import 'package:vibration/vibration.dart';
import "package:flutter/services.dart";

Future<void> vibrateTap() async {
  if (Platform.isIOS) {
    HapticFeedback.mediumImpact();
  } else {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 50);
    }
  }
}
