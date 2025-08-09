import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class GlobalErrorHandler {
  static void handleError(dynamic error, StackTrace? stackTrace) {
    debugPrint('Global error handler caught: $error');
    debugPrint('Stack trace: $stackTrace');
    
    try {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    } catch (e) {
      debugPrint('Failed to report error to Crashlytics: $e');
    }
  }
}

class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  const Result.success(this.data) : error = null, isSuccess = true;
  const Result.failure(this.error) : data = null, isSuccess = false;

  bool get isFailure => !isSuccess;
}
