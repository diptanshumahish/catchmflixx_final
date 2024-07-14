import 'package:flutter/material.dart';

class VideoSpeedWidget extends StatelessWidget {
  const VideoSpeedWidget({
    super.key,
    required this.child,
    this.onTap,
  });

  final void Function()? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
        child: child,
      ),
    );
  }
}
