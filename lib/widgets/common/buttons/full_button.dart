import 'package:catchmflixx/utils/vibrate/vibrations.dart';
import 'package:flutter/material.dart';
import 'package:catchmflixx/theme/typography.dart';

class FullButton extends StatelessWidget {
  final String content;
  final IconData? icon;
  final VoidCallback fn;
  final bool? notFull;
  final bool? isLoading;

  const FullButton({
    super.key,
    this.isLoading = false,
    required this.content,
    required this.fn,
    this.icon,
    this.notFull,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonWidth = (notFull == true) ? size.width / 3 : size.width;

    return SizedBox(
      width: buttonWidth,
      child: ElevatedButton(
        onPressed: (isLoading == true)
            ? null
            : () async {
                await vibrateTap();
                fn();
              },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.black, width: 1),
          ),
        ),
        child: isLoading == true
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null)
                    Icon(
                      icon,
                      color: Colors.black,
                      size: 20,
                    ),
                  if (icon != null) const SizedBox(width: 8),
                  Flexible(
                    child: AppText(
                      content,
                      variant: AppTextVariant.subtitle,
                      color: Colors.black,
                      weight: FontWeight.w600,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
