import 'package:catchmflixx/api/user/user_activity/user.activity.dart';
import 'package:catchmflixx/screens/ad/full_screen_ad_player.dart';
import 'package:flutter/material.dart';

void showFullScreenAd(BuildContext context, String videoUrl, bool skippable,
    String uuid, VoidCallback act, String title) {
  OverlayState? overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry; // Declare overlayEntry here

  overlayEntry = OverlayEntry(
    builder: (context) => FullScreenAdPlayer(
      title: title,
      skippable: skippable,
      videoUrl: videoUrl,
      onClose: () async {
        UserActivity u = UserActivity();
        await u.acknowledgeAd(uuid);
        act();
        overlayEntry.remove();
      },
    ),
  );

  overlayState.insert(overlayEntry);
}
