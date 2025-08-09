import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/utils/app/app_config.dart';
import 'package:catchmflixx/utils/error/global_error_handler.dart';
import 'package:catchmflixx/widgets/common/error_boundary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CatchMFlixxApp extends ConsumerWidget {
  const CatchMFlixxApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ErrorBoundary(
      child: _buildAppWithLocale(context, ref),
    );
  }

  Widget _buildAppWithLocale(BuildContext context, WidgetRef ref) {
    try {
      final langSet = ref.watch(languageProvider);
      return AppConfig.buildApp(langSet.loc);
    } catch (e, stackTrace) {
      GlobalErrorHandler.handleError(e, stackTrace);
      return AppConfig.buildFallbackApp();
    }
  }
}
