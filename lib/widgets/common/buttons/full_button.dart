import 'package:catchmflixx/utils/vibrate/vibrations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    final buttonWidth = notFull == null ? size.width : size.width / 3;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
        width: buttonWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(2, 2),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          child: isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (icon != null)
                      Icon(
                        icon,
                        color: Colors.black,
                        size: 20,
                      ),
                    if (icon != null) const SizedBox(width: 8),
                    Text(
                      content,
                      style: TextStyle(
                        fontFamily: "Kollektif",
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
        ),
      ),
      onPressed: () async {
        await vibrateTap();
        fn();
      },
    );
  }
}
