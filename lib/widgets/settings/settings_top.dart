import 'package:cached_network_image/cached_network_image.dart';
import 'package:catchmflixx/constants/styles/gradient.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SettingsTop extends StatelessWidget {
  final String settingsText;
  final String settingsSubText;
  const SettingsTop(
      {super.key, required this.settingsText, required this.settingsSubText});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: size.height / 3,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        "https://img.playbook.com/Axh_gEkgZbsvB1VDuXm4GNvbjXXu2RUUqwToXJEJ8ZQ/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzM5NTk3ODYx/LWQ1MzItNDZmMC1i/ZDhmLTQ2NjRiYjcz/NjZmMQ"),
                    fit: BoxFit.cover)),
            child: Container(
              decoration:
                  const BoxDecoration(gradient: CFGradient.topToBottomGradient),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const PhosphorIcon(
                      PhosphorIconsBold.arrowLeft,
                      color: Colors.white,
                    )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      settingsText,
                      style: size.height > 840
                          ? TextStyles.headingMobile
                          : TextStyles.headingsSecondaryMobileForSmallerScreens,
                    ),
                    SizedBox(
                      width: size.width / 1.35,
                      child: Text(
                        settingsSubText,
                        style: TextStyles.smallSubText,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
