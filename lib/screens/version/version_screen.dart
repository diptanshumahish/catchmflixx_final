import 'package:catchmflixx/constants/images.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/screens/start/check_logged_in.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:catchmflixx/utils/version/version_check.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_full_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
          child: ListView(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Update your app to the latest version to proceed",
                      style: TextStyles.headingMobile,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Please update the app to the latest version to experience catchmflixx at it's best",
                      style: TextStyles.detailsMobile,
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
                        content: "I've updated already!",
                        fn: () async {
                          if (await isVersionUpToDate()) {
                            navigateToPage(context, const CheckLoggedIn());
                          } else {
                            ToastShow.returnToast(
                                "Please check again, you are not yet updated");
                          }
                        })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
