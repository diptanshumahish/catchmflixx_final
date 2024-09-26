import 'dart:async';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenAdPlayer extends StatefulWidget {
  final String videoUrl;
  final VoidCallback onClose;
  final bool skippable;
  final String title;

  const FullScreenAdPlayer({
    super.key,
    required this.skippable,
    required this.videoUrl,
    required this.onClose,
    required this.title,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FullScreenAdPlayerState createState() => _FullScreenAdPlayerState();
}

class _FullScreenAdPlayerState extends State<FullScreenAdPlayer> {
  late VideoPlayerController _controller;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      });

    _timer = Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      if (_controller.value.isCompleted) {
        widget.onClose();
        timer.cancel();
      } else {
        setState(() {
        });
      }
    });

    _controller.addListener(() {
      if (_controller.value.isInitialized) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const CircularProgressIndicator(),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyles.cardHeading.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Ad",
                  style: TextStyles.formSubTitle,
                ),
              ],
            ),
          ),
          (_controller.value.isCompleted || widget.skippable)
              ? Positioned(
                  top: 40,
                  right: 20,
                  child: IconButton(
                    icon:
                        const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: widget.onClose,
                  ),
                )
              : const SizedBox.shrink(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              value: _controller.value.isInitialized &&
                      _controller.value.duration.inSeconds > 0
                  ? _controller.value.position.inSeconds /
                      _controller.value.duration.inSeconds
                  : 0,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.yellowAccent),
            ),
          ),
        ],
      ),
    );
  }
}
