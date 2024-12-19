import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoaderSpinner extends StatelessWidget {
  final double? radius;
  const LoaderSpinner({super.key, this.radius});

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(
      radius: (radius != null) ? radius! : 8,
      color: Colors.white,
    );
  }
}
