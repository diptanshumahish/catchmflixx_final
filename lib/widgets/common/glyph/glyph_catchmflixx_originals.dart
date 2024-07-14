import 'package:catchmflixx/constants/images.dart';
import 'package:flutter/material.dart';

class CatchMFlixxOriginals extends StatelessWidget {
  const CatchMFlixxOriginals({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          CatchMFlixxImages.logo,
          height: 15,
        ),
        const SizedBox(
          width: 10,
        ),
        const Text(
          "CATCHMFLIXX ORIGINALS",
          style: TextStyle(
              fontSize: 12, color: Colors.white54, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
