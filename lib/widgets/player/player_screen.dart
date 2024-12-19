import 'dart:io';

import 'package:catchmflixx/constants/images.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_full_button.dart';
import 'package:catchmflixx/widgets/player/player_packages/lib/lecle_yoyo_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class PlayerScreen extends StatefulWidget {
  final String title;
  final String details;
  final String playLink;
  final String id;
  final int seekTo;
  final String type;
  final VoidCallback act;
  const PlayerScreen(
      {super.key,
      required this.title,
      required this.details,
      required this.playLink,
      required this.id,
      required this.seekTo,
      required this.type,
      required this.act});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  void initState() {
    setDataLeakage();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // print("here we have 💵💵💵💵💵💵💵💵");
    // print(widget.seekTo);

    super.initState();
  }

  setDataLeakage() async {
    try {
      if (Platform.isIOS) {
        await ScreenProtector.protectDataLeakageWithColor(Colors.black);
      } else {
        await ScreenProtector.protectDataLeakageOn();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  removeDataLeakage() async {
    try {
      await ScreenProtector.protectDataLeakageOff();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    removeDataLeakage();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    widget.act();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.playLink == "" || widget.playLink == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                CatchMFlixxImages.nope,
                height: 90,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Error in playback",
                style: TextStyles.cardHeading,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: 120,
                  child: OffsetFullButton(
                      content: "Go back",
                      fn: () {
                        Navigator.pop(context);
                      }))
            ],
          ),
        ),
      );
    }

    return Scaffold(
      // extendBody: true,
      extendBodyBehindAppBar: true,

      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        left: false,
        bottom: false,
        right: false,
        child: Stack(
          children: [
            SizedBox.expand(
              child: YoYoPlayer(
                last: Duration(seconds: widget.seekTo ?? 0),
                id: widget.id,
                title: widget.title,
                details: widget.details,
                onShowMenu: (show, _) {},
                url: widget.playLink,
                autoPlayVideoAfterInit: true,
                allowCacheFile: false,
                videoLoadingStyle: VideoLoadingStyle(
                    loadingBackgroundColor: Colors.black,
                    loading: Center(
                      child: Shimmer.fromColors(
                        baseColor: Colors.transparent,
                        highlightColor: Colors.white,
                        period: const Duration(seconds: 2),
                        child: SvgPicture.asset(
                          CatchMFlixxImages.textLogo,
                          height: 30,
                        ),
                      ),
                    )),
                videoStyle: const VideoStyle(
                  allowScrubbing: true,
                  actionBarPadding: EdgeInsets.all(15),
                  videoSeekStyle: TextStyles.cardHeading,
                  enableSystemOrientationsOverride: true,
                  progressIndicatorColors: VideoProgressColors(
                      backgroundColor: Colors.white24,
                      bufferedColor: Colors.white54,
                      playedColor: Colors.white),
                  orientation: [DeviceOrientation.landscapeLeft],
                  spaceBetweenBottomBarButtons: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
