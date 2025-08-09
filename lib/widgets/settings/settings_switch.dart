import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:catchmflixx/utils/responsive/responsive_utils.dart';

class SettingsSwitch extends StatelessWidget {
  final String heading;
  final String subHeading;
  final bool switchBool;
  final void Function(bool) fn;
  const SettingsSwitch(
      {super.key,
      required this.heading,
      required this.subHeading,
      required this.switchBool,
      required this.fn});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 120,
                child: Text(
                  heading,
                  style: TextStyles.getResponsiveCardHeading(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 120,
                child: Text(
                  subHeading,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.getResponsiveSmallSubText(context),
                  maxLines: 1,
                  softWrap: true,
                ),
              ),
            ],
          ),
          CupertinoSwitch(
              activeTrackColor: Colors.blue,
              value: switchBool,
              onChanged: (val) {
                fn(val);
              })
        ],
      ),
    );
  }
}
