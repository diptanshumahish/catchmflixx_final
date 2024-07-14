import 'package:cached_network_image/cached_network_image.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsTopBar extends ConsumerWidget {
  final String plans;
  const SettingsTopBar({
    super.key,
    required this.plans,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return FlexibleSpaceBar(
        background: Stack(
      children: [
        CachedNetworkImage(
          width: size.width,
          height: double.infinity,
          imageUrl:
              "https://img.playbook.com/Axh_gEkgZbsvB1VDuXm4GNvbjXXu2RUUqwToXJEJ8ZQ/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzM5NTk3ODYx/LWQ1MzItNDZmMC1i/ZDhmLTQ2NjRiYjcz/NjZmMQ",
          fit: BoxFit.cover,
        ),
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54, Colors.black])),
        ),
        Padding(
          padding: EdgeInsets.all(size.height / 40),
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plans,
                  style: size.height > 840
                      ? TextStyles.headingMobile
                      : TextStyles.headingMobileSmallScreens,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
