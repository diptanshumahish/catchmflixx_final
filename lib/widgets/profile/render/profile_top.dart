import 'package:cached_network_image/cached_network_image.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/screens/main/main_screen/settings_screen.dart';
import 'package:catchmflixx/screens/profile/profile_management.screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vibration/vibration.dart';

class ProfileTop extends StatelessWidget {
  final String settingsText;
  final String settingsSubText;
  final String? image;
  const ProfileTop(
      {super.key,
      required this.settingsText,
      required this.settingsSubText,
      required this.image});

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
                          image: CachedNetworkImageProvider(image ??
                              "https://img.playbook.com/Axh_gEkgZbsvB1VDuXm4GNvbjXXu2RUUqwToXJEJ8ZQ/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzM5NTk3ODYx/LWQ1MzItNDZmMC1i/ZDhmLTQ2NjRiYjcz/NjZmMQ"),
                          fit: BoxFit.cover)),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        settingsText,
                        style: size.height > 840
                            ? TextStyles.headingMobile
                            : TextStyles
                                .headingsSecondaryMobileForSmallerScreens,
                      ),
                      Text(
                        settingsSubText,
                        style: TextStyles.smallSubText,
                      )
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
                      onTap: () {
                        Vibration.vibrate(duration: 50);
                        Navigator.push(
                            context,
                            PageTransition(
                                child: const SettingsScreen(),
                                type: PageTransitionType.bottomToTop,
                                curve: Curves.easeInOut,
                                isIos: true));
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PhosphorIcon(
                            PhosphorIconsLight.gear,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "App settings",
                            style: TextStyles.cardHeading,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Vibration.vibrate(duration: 50);
                        Navigator.push(
                            context,
                            PageTransition(
                                child: const ProfileManagement(),
                                type: PageTransitionType.bottomToTop));
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PhosphorIcon(
                            PhosphorIconsLight.userGear,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Profile settings",
                            style: TextStyles.cardHeading,
                          ),
                        ],
                      ),
                    )
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
