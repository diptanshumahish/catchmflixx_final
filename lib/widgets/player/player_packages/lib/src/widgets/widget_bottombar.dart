import 'dart:async';

import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/widgets/player/player_packages/lib/lecle_yoyo_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:video_player/video_player.dart';

bool _zeroUp = false;

class PlayerBottomBar extends StatefulWidget {
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
    required this.visible,
  });
  final bool visible;
  final VideoPlayerController controller;
  final bool showBottomBar;
  final String videoSeek;
  final String videoDuration;
  final void Function()? onPlayButtonTap;
  final VideoStyle videoStyle;
  final ValueChanged<VideoPlayerValue>? onRewind;
  final ValueChanged<VideoPlayerValue>? onFastForward;

  @override
  _PlayerBottomBarState createState() => _PlayerBottomBarState();
}

class _PlayerBottomBarState extends State<PlayerBottomBar> {
  late ValueNotifier<double> _sliderValueNotifier;
  late Timer _timer;
  void _updateSliderValue() {
    final duration = widget.controller.value.duration;
    final position = widget.controller.value.position;

    if (duration.inSeconds > 0) {
      _sliderValueNotifier.value = position.inSeconds / duration.inSeconds;
    }
  }

  @override
  void initState() {
    super.initState();
    _sliderValueNotifier = ValueNotifier(0.0);
    widget.controller.addListener(_updateSliderValue);
    _timer = Timer.periodic(const Duration(seconds: 1), (time) {
      if (widget.controller.value.isPlaying == false && _zeroUp == false) {
        _updateSliderValue();
        setState(() {
          _zeroUp = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _zeroUp = false;
    _timer.cancel();
    widget.controller.removeListener(_updateSliderValue);
    _sliderValueNotifier.dispose();
    super.dispose();
  }

  Widget buildScrubber() {
    return Expanded(
      child: ValueListenableBuilder<double>(
        valueListenable: _sliderValueNotifier,
        builder: (context, value, child) {
          final duration = widget.controller.value.duration;
          return Animate(
            effects: const [FadeEffect(delay: Duration(milliseconds: 400))],
            child: Slider(
              activeColor: Colors.white,
              inactiveColor: Colors.white30,
              thumbColor: Colors.white,
              value: value,
              onChangeStart: (newValue) {
                // widget.controller.pause();
              },
              onChanged: (newValue) {
                // setState(() {
                //   value = newValue;
                // });
                _sliderValueNotifier.value = newValue;
              },
              onChangeEnd: (newValue) {
                final seekTo = Duration(
                  milliseconds: (newValue * duration.inMilliseconds).toInt(),
                );
                widget.controller.seekTo(seekTo);
                if (widget.controller.value.isPlaying) {
                  widget.controller.play();
                }
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                widget.videoSeek,
                style: TextStyles.formSubTitle,
              ),
            ),
            buildScrubber(),
            Padding(
              padding: const EdgeInsets.only(right: 30, left: 20),
              child: Text(
                widget.videoDuration,
                style: TextStyles.formSubTitle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
