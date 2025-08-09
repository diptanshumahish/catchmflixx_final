import 'package:catchmflixx/utils/app/app_initialization_service.dart';
import 'package:catchmflixx/widgets/app/catchmflixx_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  final initResult = await AppInitializationService.initializeApp();
  
  if (initResult.isFailure) {
    debugPrint('App initialization failed: ${initResult.error}');
  }

  runApp(const ProviderScope(child: CatchMFlixxApp()));
}
