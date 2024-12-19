import 'dart:io';

import 'package:catchmflixx/widgets/player/player_packages/lib/src/utils/extensions/video_controller_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:video_player/video_player.dart';

class VideoControls extends StatelessWidget {
  const VideoControls({
    super.key,
    required this.controller,
    required this.showControls,
    this.onFastForward,
    this.onRewind,
    this.onPlayButtonTap,
  });

  final VideoPlayerController controller;
  final bool showControls;
  final ValueChanged<VideoPlayerValue>? onRewind;
  final ValueChanged<VideoPlayerValue>? onFastForward;
  final void Function()? onPlayButtonTap;

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: showControls,
        child: Positioned.fill(
          child: Center(
            child:controller.value.isCompleted?GestureDetector() : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Animate(
                  effects: const [
                    FadeEffect(delay: Duration(milliseconds: 100))
                  ],
                  child: GestureDetector(
                      onTap: () {
                        controller.rewind().then((value) {
                          onRewind?.call(controller.value);
                        });
                      },
                      child: const PhosphorIcon(
                        PhosphorIconsFill.clockCounterClockwise,
                        color: Colors.white,
                        size: 32,
                      )),
                ),
                const SizedBox(
                  width: 16,
                ),
                Animate(
                  effects: const [FadeEffect()],
                  child: GestureDetector(
                    onTap: onPlayButtonTap,
                    child: () {
                     
                      if (controller.value.isBuffering) {
                        return (Platform.isIOS)
                            ? const CupertinoActivityIndicator(
                                color: Colors.white,
                                radius: 30,
                              )
                            : const CircularProgressIndicator(
                                color: Colors.white,
                              );
                      }
                      var defaultIcon = PhosphorIcon(
                        controller.value.isPlaying
                            ? PhosphorIconsFill.pause
                            : PhosphorIconsFill.play,
                        duotoneSecondaryColor: Colors.white,
                        color: Colors.white,
                        size: 60,
                      );

                      return defaultIcon;
                    }(),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Animate(
                  effects: const [
                    FadeEffect(delay: Duration(milliseconds: 100))
                  ],
                  child: GestureDetector(
                    onTap: () {
                      controller.fastForward().then((value) {
                        onFastForward?.call(controller.value);
                      });
                    },
                    child: const PhosphorIcon(
                      PhosphorIconsFill.clockClockwise,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
