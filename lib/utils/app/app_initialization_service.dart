import 'dart:io' show Platform;
import 'package:catchmflixx/api/common/network.dart';
import 'package:catchmflixx/firebase_options.dart';
import 'package:catchmflixx/utils/error/global_error_handler.dart';
import 'package:catchmflixx/utils/firebase/firebase_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

class AppInitializationService {
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 2);

  static Future<Result<void>> initializeApp() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      
      final orientationResult = await _setupOrientation();
      if (orientationResult.isFailure) {
        debugPrint('Orientation setup failed: ${orientationResult.error}');
      }
      
      final displayModeResult = await _setupDisplayMode();
      if (displayModeResult.isFailure) {
        debugPrint('Display mode setup failed: ${displayModeResult.error}');
      }
      
      final firebaseResult = await _initializeFirebase();
      if (firebaseResult.isFailure) {
        debugPrint('Firebase initialization failed: ${firebaseResult.error}');
      }
      
      _setupErrorReporting();
      
      final networkResult = await _initializeNetworkManager();
      if (networkResult.isFailure) {
        debugPrint('Network manager initialization failed: ${networkResult.error}');
      }

      return const Result.success(null);
    } catch (e, stackTrace) {
      GlobalErrorHandler.handleError(e, stackTrace);
      return Result.failure('App initialization failed: $e');
    }
  }

  static Future<Result<void>> _setupOrientation() async {
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      return const Result.success(null);
    } catch (e) {
      return Result.failure('Failed to set orientation: $e');
    }
  }

  static Future<Result<void>> _setupDisplayMode() async {
    if (!Platform.isAndroid) {
      return const Result.success(null);
    }

    try {
      await FlutterDisplayMode.setHighRefreshRate();
      debugPrint('High refresh rate set successfully');
      return const Result.success(null);
    } catch (e) {
      debugPrint('Failed to set high refresh rate: $e');
      return const Result.success(null);
    }
  }

  static Future<Result<void>> _initializeFirebase() async {
    int retries = _maxRetries;
    Exception? lastException;

    while (retries > 0) {
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        
        await _initializeFirebaseMessaging();
        
        debugPrint('Firebase initialized successfully');
        return const Result.success(null);
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        retries--;
        
        debugPrint('Firebase initialization failed (attempts left: $retries): $e');
        
        if (retries > 0) {
          debugPrint('Retrying Firebase initialization in ${_retryDelay.inSeconds} seconds...');
          await Future.delayed(_retryDelay);
        }
      }
    }

    final errorMessage = 'Firebase initialization failed after $_maxRetries attempts. Last error: $lastException';
    debugPrint(errorMessage);
    return Result.failure(errorMessage);
  }

  static Future<void> _initializeFirebaseMessaging() async {
    try {
      await FirebaseApi().initNotifications();
      debugPrint('Firebase Messaging initialized successfully');
    } catch (e) {
      debugPrint('Firebase Messaging initialization failed: $e');
    }
  }

  static void _setupErrorReporting() {
    FlutterError.onError = (errorDetails) {
      debugPrint('Flutter error caught: ${errorDetails.exception}');
      try {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      } catch (e) {
        debugPrint('Failed to report Flutter error to Crashlytics: $e');
      }
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('Platform error caught: $error');
      try {
        FirebaseCrashlytics.instance.recordError(error, stack);
      } catch (e) {
        debugPrint('Failed to report platform error to Crashlytics: $e');
      }
      return true;
    };
  }

  static Future<Result<void>> _initializeNetworkManager() async {
    try {
      final networkManager = NetworkManager();
      await networkManager.init();
      debugPrint('Network manager initialized successfully');
      return const Result.success(null);
    } catch (e) {
      final errorMessage = 'Failed to initialize network manager: $e';
      debugPrint(errorMessage);
      return Result.failure(errorMessage);
    }
  }
}
