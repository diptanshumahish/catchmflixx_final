import 'package:catchmflixx/utils/vibrate/vibrations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
        width: buttonWidth,
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C), // Dark background color
          borderRadius:
              BorderRadius.circular(8), // Slightly larger border radius
          border: Border.all(color: Colors.white24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: Offset(0, 2),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null)
                Icon(
                  icon!.icon,
                  size: 18,
                  color: Colors.white,
                ),
              if (icon != null) const SizedBox(width: 8),
              Text(
                content,
                style: const TextStyle(
                  fontFamily: "Kollektif",
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16, // Increased font size for better readability
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      onPressed: () async {
        await vibrateTap(); // Assuming vibrateTap provides haptic feedback
        fn();
      },
    );
  }
}
