import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  final String url;
  const TestScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(url),
      ),
    );
  }
}
