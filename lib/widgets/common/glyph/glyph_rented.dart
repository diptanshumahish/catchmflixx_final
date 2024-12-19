import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class GlyphRented extends StatelessWidget {
  final bool isRented;
  const GlyphRented({super.key, required this.isRented});

  @override
  Widget build(BuildContext context) {
    if (isRented == true) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhosphorIcon(
            PhosphorIconsLight.ticket,
            color: Colors.white54,
            size: 15,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "Rented",
            style: TextStyles.smallSubText,
          )
        ],
      );
    } else {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhosphorIcon(
            PhosphorIconsLight.x,
            color: Colors.white54,
            size: 15,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "Rent to watch",
            style: TextStyles.smallSubText,
          )
        ],
      );
    }
  }
}
