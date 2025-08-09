import 'package:catchmflixx/utils/vibrate/vibrations.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:catchmflixx/theme/typography.dart';

class GoogleFullButton extends StatelessWidget {
  final String content;
  final VoidCallback fn;
  final bool isLoading;

  const GoogleFullButton({
    super.key,
    required this.content,
    required this.fn,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () async {
                await vibrateTap();
                fn();
              },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF111827),
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const PhosphorIcon(
                    PhosphorIconsRegular.googleLogo,
                    color: Colors.black,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  const SizedBox(width: 2),
                  Flexible(
                    child: AppText(
                      content,
                      variant: AppTextVariant.subtitle,
                      color: const Color(0xFF111827),
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


