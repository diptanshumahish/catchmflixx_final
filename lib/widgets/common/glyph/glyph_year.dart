import 'package:flutter/material.dart';

class GlyphYear extends StatelessWidget {
  final String year;
  const GlyphYear({
    super.key,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.calendar_month,
          color: Colors.white60,
          size: 15,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          year,
          style: const TextStyle(
              color: Colors.white70, fontWeight: FontWeight.w500, fontSize: 14),
        )
      ],
    );
  }
}
