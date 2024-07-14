import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/widgets/player/player_packages/lib/lecle_yoyo_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:video_player/video_player.dart';

class PlayerBottomBar extends StatelessWidget {
  const PlayerBottomBar({
    super.key,
    required this.controller,
    required this.showBottomBar,
    this.onPlayButtonTap,
    this.videoDuration = "00:00:00",
    this.videoSeek = "00:00:00",
    this.videoStyle = const VideoStyle(),
    this.onFastForward,
    this.onRewind,
  });

  final VideoPlayerController controller;
  final bool showBottomBar;
  final String videoSeek;
  final String videoDuration;
  final void Function()? onPlayButtonTap;
  final VideoStyle videoStyle;
  final ValueChanged<VideoPlayerValue>? onRewind;
  final ValueChanged<VideoPlayerValue>? onFastForward;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: showBottomBar,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 16),
        child: Animate(
          effects: const [FadeEffect(delay: Duration(milliseconds: 100))],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 10),
                child: Text(
                  videoSeek,
                  style: TextStyles.formSubTitle,
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: VideoProgressIndicator(
                    controller,
                    allowScrubbing: videoStyle.allowScrubbing ?? true,
                    colors: videoStyle.progressIndicatorColors ??
                        const VideoProgressColors(
                          playedColor: Color.fromARGB(250, 0, 255, 112),
                        ),
                    padding:
                        videoStyle.progressIndicatorPadding ?? EdgeInsets.zero,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30, left: 20),
                child: Text(
                  videoDuration,
                  style: TextStyles.formSubTitle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
