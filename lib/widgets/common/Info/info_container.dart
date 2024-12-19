import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/widgets/common/buttons/full_button.dart';
import 'package:flutter/material.dart';

class InfoContainer extends StatelessWidget {
  final String data;
  final VoidCallback fn;
  final String action;
  final Color color;
  final IconData? icon;
  const InfoContainer(
      {super.key,
      required this.data,
      required this.fn,
      required this.action,
      required this.color,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white38)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              data,
              style: TextStyles.smallSubTextActive,
            ),
            FullButton(
                icon: icon,
                content: action,
                fn: () {
                  fn();
                })
          ],
        ),
      ),
    );
  }
}
