import 'package:catchmflixx/utils/vibrate/vibrations.dart';
import 'package:flutter/material.dart';
import 'package:catchmflixx/theme/typography.dart';

class SecondaryFullButton extends StatelessWidget {
  final String content;
  final Icon? icon;
  final VoidCallback fn;
  final bool? notFull;

  const SecondaryFullButton({
    super.key,
    required this.content,
    required this.fn,
    this.icon,
    this.notFull,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonWidth = notFull == null ? size.width : size.width / 2;

    return SizedBox(
      width: buttonWidth,
      child: OutlinedButton(
        onPressed: () async {
          await vibrateTap();
          fn();
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white38, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          foregroundColor: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon!.icon,
                size: 18,
                color: Colors.white,
              ),
            if (icon != null) const SizedBox(width: 8),
            AppText(
              content,
              variant: AppTextVariant.subtitle,
              color: Colors.white,
              weight: FontWeight.w600,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
