import 'package:catchmflixx/constants/images.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/widgets/player/player_packages/lib/lecle_yoyo_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class PlayerScreen extends StatefulWidget {
  final String title;
  final String details;
  final String playLink;
  final String id;
  final int? seekTo;
  final String type;
  final VoidCallback act;
  const PlayerScreen(
      {super.key,
      required this.title,
      required this.details,
      required this.playLink,
      required this.id,
      this.seekTo,
      required this.type,
      required this.act});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    widget.act();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: YoYoPlayer(
              last: Duration(seconds: widget.seekTo ?? 0),
              id: widget.id,
              title: widget.title,
              details: widget.details,
              onShowMenu: (show, _) {},
              url: widget.playLink,
              autoPlayVideoAfterInit: true,
              allowCacheFile: true,
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
    );
  }
}
