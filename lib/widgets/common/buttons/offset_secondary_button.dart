import 'package:catchmflixx/utils/vibrate/vibrations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OffsetSecondaryFullButton extends StatelessWidget {
  final String content;
  final Icon? icon;
  final VoidCallback fn;
  final bool? notFull;
  const OffsetSecondaryFullButton(
      {super.key,
      required this.content,
      required this.fn,
      this.icon,
      this.notFull});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CupertinoButton(
        padding: EdgeInsets.zero,
        child: Container(
          width: notFull == null ? size.width : size.width / 2,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white54),
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(2, 2),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ]),
          child: Padding(
            padding:
                EdgeInsets.symmetric(vertical: size.height > 840 ? 16.0 : 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                (icon == null)
                    ? const SizedBox()
                    : Icon(
                        icon!.icon,
                        color: Colors.white,
                        size: 19,
                      ),
                (icon == null)
                    ? const SizedBox()
                    : const SizedBox(
                        width: 5,
                      ),
                Text(
                  content,
                  style: TextStyle(
                    fontFamily: "Kollektif",
                    fontSize: size.height > 840 ? 15 : 14,
                    color: Colors.white,
                    letterSpacing: 0.4,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
        onPressed: () async {
          await vibrateTap();
          fn();
        });
  }
}
