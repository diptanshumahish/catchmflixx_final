import 'package:catchmflixx/constants/images.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class VideoTopBar extends StatelessWidget {
  final String title;
  final String details;
  final VoidCallback act;
  final bool showBar;
  const VideoTopBar(
      {super.key,
      required this.showBar,
      required this.title,
      required this.details,
      required this.act});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: showBar,
      child: Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Animate(
            effects: const [FadeEffect()],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Image.asset(
                      CatchMFlixxImages.logo,
                      height: 40,
                      width: 40,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 500,
                          child: Text(
                            title,
                            style: TextStyles.headingMobile,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 500,
                          child: Text(
                            details,
                            style: TextStyles.smallSubText,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () {
                      act();
                    },
                    icon: const PhosphorIcon(
                      PhosphorIconsBold.x,
                      color: Colors.white,
                    ))
              ],
            ),
          )),
    );
  }
}
