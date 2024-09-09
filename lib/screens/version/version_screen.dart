import 'package:catchmflixx/constants/images.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:catchmflixx/utils/version/version_check.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_full_button.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionScreen extends StatelessWidget {
  const VersionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          bottom: true,
          top: true,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Update your app to the latest version to proceed",
                  style: TextStyles.headingMobile,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Please update the app to the latest version to experience catchmflixx at it's best",
                  style: TextStyles.detailsMobile,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                SvgPicture.asset(CatchMFlixxImages.nope),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Update the app to start watching content again✨",
                  style: TextStyles.detailsMobile,
                ),
                const SizedBox(
                  height: 20,
                ),
                OffsetFullButton(
                    content: "Update now",
                    fn: () async {
                      await launchUrl(Uri.parse(
                          "https://play.google.com/store/apps/details?id=com.diptanshumahish.catchmflixxapp"));
                    }),
                const SizedBox(
                  height: 10,
                ),
                OffsetSecondaryFullButton(
                    content: "I've updated already!",
                    fn: () async {
                      if (await isVersionUpToDate()) {
                        navigateToPage(context, "/check-login");
                      } else {
                        ToastShow.returnToast(
                            "Please check again, you are not yet updated");
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
