import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class FullButton extends StatelessWidget {
  final String content;
  final IconData? icon;
  final VoidCallback fn;
  final bool? notFull;
  final bool? isLoading;
  const FullButton(
      {super.key,
      this.isLoading = false,
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
          width: notFull == null ? size.width : size.width / 3,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: isLoading == true
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Colors.black,
                  ))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      icon != null
                          ? Icon(
                              icon,
                              color: Colors.black,
                              size: 18,
                            )
                          : const SizedBox.shrink(),
                      icon != null
                          ? const SizedBox(
                              width: 5,
                            )
                          : const SizedBox.shrink(),
                      Text(
                        content,
                        style: const TextStyle(
                            fontFamily: "Kollektif",
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
          ),
        ),
        onPressed: () {
          Vibration.vibrate(duration: 15);
          fn();
        });
  }
}
