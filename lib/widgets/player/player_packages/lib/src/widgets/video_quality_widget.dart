import 'package:catchmflixx/widgets/player/player_packages/lib/lecle_yoyo_player.dart';
import 'package:flutter/material.dart';

class VideoQualityWidget extends StatelessWidget {
  const VideoQualityWidget({
    super.key,
    required this.child,
    this.onTap,
    this.videoStyle = const VideoStyle(),
  });

  final void Function()? onTap;
  final Widget child;
  final VideoStyle videoStyle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: videoStyle.videoQualityPadding ??
            const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
        child: child,
      ),
    );
  }
}
