import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecondaryFullButton extends StatelessWidget {
  final String content;
  final Icon? icon;
  final VoidCallback fn;
  final bool? notFull;
  const SecondaryFullButton(
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
            border: Border.all(color: Colors.white24),
            color: const Color(0xFF181818),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (icon == null)
                    ? const SizedBox()
                    : Icon(
                        icon!.icon,
                        size: 16,
                        color: Colors.white,
                      ),
                (icon == null)
                    ? const SizedBox()
                    : const SizedBox(
                        width: 5,
                      ),
                Text(
                  content,
                  style: const TextStyle(
                      fontFamily: "Kollektif",
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        onPressed: () => {fn()});
  }
}
