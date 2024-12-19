import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Oops! Something went wrong.",
                  style: TextStyles.headingMobileSmallScreens, // Customize this style for the heading
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                const Text(
                  "We're having trouble connecting to the network. Please close the app and try again.",
                  style: TextStyles.formSubTitle, // Customize this for body text
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "If the issue persists, please contact our support team at:",
                  style: TextStyles.smallSubText, // Subtle subtitle text
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                const Text(
                  "support@catchmflix.com",
                  style: TextStyles.formSubTitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                   navigateToPage(context, "/");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  ),
                  child: const Text(
                    "Retry",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
