import 'package:cached_network_image/cached_network_image.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/vibrate/vibrations.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProfileTop extends StatelessWidget {
  final String settingsText;
  final String settingsSubText;
  final String planLabel;
  final String? image;

  const ProfileTop({
    super.key,
    required this.settingsText,
    required this.settingsSubText,
    required this.planLabel,
    required this.image,
  });

  Color _planColor(String name) {
    switch (name.toLowerCase()) {
      case "premium":
        return Colors.amber;
      case "pro":
        return Colors.blueAccent;
      case "standard":
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        image ??
                            "https://img.playbook.com/Axh_gEkgZbsvB1VDuXm4GNvbjXXu2RUUqwToXJEJ8ZQ/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzM5NTk3ODYx/LWQ1MzItNDZmMC1i/ZDhmLTQ2NjRiYjcz/NjZmMQ",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        settingsText,
                        style: size.height > 840
                            ? TextStyles.headingMobile
                            : TextStyles.headingsSecondaryMobileForSmallerScreens,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        settingsSubText,
                        style: TextStyles.smallSubText,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _planColor(planLabel).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Plan: $planLabel",
                          style: TextStyle(
                            color: _planColor(planLabel),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white12,
                    width: 2.0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await vibrateTap();
                        navigateToPage(context, "/settings");
                      },
                      child: const Row(
                        children: [
                          PhosphorIcon(
                            PhosphorIconsLight.gear,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "App settings",
                            style: TextStyles.cardHeading,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () async {
                        await vibrateTap();
                        navigateToPage(context, "/user/profile-management");
                      },
                      child: const Row(
                        children: [
                          PhosphorIcon(
                            PhosphorIconsLight.userGear,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Profile settings",
                            style: TextStyles.cardHeading,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
