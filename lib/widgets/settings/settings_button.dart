import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  final String headingName;
  final String subHeading;
  final IconData icon;
  final VoidCallback fn;
  const SettingsButton(
      {super.key,
      required this.headingName,
      required this.subHeading,
      required this.icon,
      required this.fn});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        fn();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headingName,
                  style: TextStyles.getResponsiveCardHeading(context),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
                  child: Text(
                    subHeading,
                    style: TextStyles.getResponsiveSmallSubText(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Icon(
              icon,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
