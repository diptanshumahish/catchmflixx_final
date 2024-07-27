import 'dart:io';

import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:vibration/vibration.dart';

Future<void> vibrateTap() async {
  if (Platform.isIOS) {
    final canVibrate = await Haptics.canVibrate();
    if (canVibrate) {
      await Haptics.vibrate(HapticsType.soft);
    }
  } else {
    Vibration.vibrate(duration: 50);
  }
}
