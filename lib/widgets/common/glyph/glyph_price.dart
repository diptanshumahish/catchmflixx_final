import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class GlyphPrice extends StatelessWidget {
  final bool isPaid;
  const GlyphPrice({super.key, required this.isPaid});

  @override
  Widget build(BuildContext context) {
    if (isPaid == false) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhosphorIcon(
            PhosphorIconsLight.currencyInr,
            color: Colors.white54,
            size: 15,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "Premium",
            style: TextStyles.smallSubText,
          )
        ],
      );
    } else {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhosphorIcon(
            PhosphorIconsLight.filmReel,
            color: Colors.white54,
            size: 15,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "Free",
            style: TextStyles.smallSubText,
          )
        ],
      );
    }
  }
}
