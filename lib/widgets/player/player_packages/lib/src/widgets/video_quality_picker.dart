import 'dart:ui';

import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/utils/player/return_quality.dart';
import 'package:catchmflixx/widgets/player/player_packages/lib/lecle_yoyo_player.dart';
import 'package:catchmflixx/widgets/player/player_packages/lib/src/model/m3u8.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class VideoQualityPicker extends StatelessWidget {
  final List<M3U8Data> videoData;
  final bool showPicker;
  final double? positionRight;
  final double? positionTop;
  final double? positionLeft;
  final double? positionBottom;
  final VideoStyle videoStyle;
  final void Function(M3U8Data data)? onQualitySelected;

  const VideoQualityPicker({
    super.key,
    required this.videoData,
    this.videoStyle = const VideoStyle(),
    this.showPicker = false,
    this.positionRight,
    this.positionTop,
    this.onQualitySelected,
    this.positionLeft,
    this.positionBottom,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: showPicker,
      child: Animate(
        effects: const [FadeEffect()],
        child: Positioned.fill(
          child: GestureDetector(
            onTap: () {
              onQualitySelected?.call(videoData[0]);
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: videoStyle.qualityOptionsRadius ??
                      BorderRadius.circular(4.0),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Material(
                            color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 4),
                                  child: PhosphorIcon(
                                    PhosphorIconsBold.gearFine,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    "Choose Video quality",
                                    style: TextStyles.headingMobile,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    "select your desired video quality, higher quality consumes higher data",
                                    style: TextStyles.smallSubText,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Wrap(
                                  alignment: WrapAlignment.start,
                                  children: List.generate(
                                      videoData.length,
                                      (index) => Animate(
                                            effects: [
                                              FadeEffect(
                                                  delay: Duration(
                                                      milliseconds: index * 70))
                                            ],
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () {
                                                  onQualitySelected
                                                      ?.call(videoData[index]);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16),
                                                  margin: const EdgeInsets.only(
                                                      right: 5,
                                                      top: 10,
                                                      left: 0,
                                                      bottom: 10),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    returnQuality(
                                                        videoData[index]
                                                                .dataQuality ??
                                                            "Auto"),
                                                    style:
                                                        TextStyles.cardHeading,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
