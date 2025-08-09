import 'dart:async';
import 'package:flutter/material.dart';
import 'package:screen_protector/screen_protector.dart';

class SecureScreenWrapper extends StatefulWidget {
  final Widget child;
  final bool hideOnRecording;

  const SecureScreenWrapper({
    super.key,
    required this.child,
    this.hideOnRecording = true,
  });

  @override
  State<SecureScreenWrapper> createState() => _SecureScreenWrapperState();
}

class _SecureScreenWrapperState extends State<SecureScreenWrapper> {
  bool _isRecording = false;
  Timer? _recordingCheckTimer;

  @override
  void initState() {
    super.initState();
    _activateSecurity();
  }

  Future<void> _activateSecurity() async {
    await ScreenProtector.preventScreenshotOn();

    // Optional: check recording status periodically
    _checkRecording();
    _recordingCheckTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _checkRecording();
    });
  }

  Future<void> _checkRecording() async {
    final isRecording = await ScreenProtector.isRecording();
    if (_isRecording != isRecording) {
      setState(() {
        _isRecording = isRecording;
      });
    }
  }

  @override
  void dispose() {
    _recordingCheckTimer?.cancel();
    ScreenProtector.preventScreenshotOff();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hideOnRecording && _isRecording) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 80,
                  color: Colors.redAccent,
                ),
                SizedBox(height: 24),
                Text(
                  'Screen Recording Detected',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'For your security, this content is hidden while screen recording is active.\n\nPlease stop recording to continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return widget.child;
  }
}
