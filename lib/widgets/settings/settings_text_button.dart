import 'package:flutter/cupertino.dart';

class SettingsTextButton extends StatelessWidget {
  final String content;
  final IconData icon;
  final VoidCallback fn;
  final Color color;
  const SettingsTextButton(
      {super.key,
      required this.content,
      required this.icon,
      required this.fn,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  content,
                  style: TextStyle(color: color, fontFamily: "Kollektif"),
                ),
                const SizedBox(
                  width: 10,
                ),
                Icon(
                  icon,
                  color: color,
                ),
              ],
            ),
            onPressed: () {
              fn();
            }),
      ),
    );
  }
}
