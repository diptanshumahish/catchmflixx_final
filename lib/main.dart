import 'dart:io' show Platform;
import 'package:catchmflixx/firebase_options.dart';
import 'package:catchmflixx/screens/start/splash_screen.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/theme/theme_catchmflixx.dart';
import 'package:catchmflixx/utils/firebase/firebase_api.dart';
import 'package:catchmflixx/utils/go_router/go.dart';
// import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:screen_protector/screen_protector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //setup 120hz refresh rate.

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  try {
    await FlutterDisplayMode.setHighRefreshRate();
  } catch (e) {
    debugPrint(e.toString());
  }

  await initializeFirebase();

  runApp(const ProviderScope(child: CatchMFlixxApp()));
}

Future<void> initializeFirebase() async {
  int retries = 3;
  while (retries > 0) {
    try {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      await FirebaseApi().initNotifications();
      break;
    } catch (e) {
      retries--;
      debugPrint("Firebase initialization failed: $e");
      if (retries == 0) {
        debugPrint("Max retries reached. Firebase initialization failed.");
        ToastShow.returnToast("Error in network");
      }
    }
  }
}

class CatchMFlixxApp extends ConsumerWidget {
  const CatchMFlixxApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langSet = ref.watch(languageProvider);
    return _buildApp(context, langSet.loc);
  }

  Widget _buildApp(BuildContext context, Locale? locale) {
    const localizationsDelegates = [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ];

    const supportedLocales = [
      Locale("en"),
      Locale("hi"),
      Locale("kn"),
      Locale("ml"),
      Locale("te"),
      Locale("ta"),
    ];

    if (Platform.isIOS) {
      ScreenProtector.preventScreenshotOff();
      return CupertinoApp.router(
        routerConfig: appRoute,
        debugShowCheckedModeBanner: false,
        title: 'Catchmflixx',
        theme: CatchMFLixxThemeIOS.theme,
        locale: locale,
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
      );
    } else {
      return MaterialApp.router(
        routerConfig: appRoute,
        debugShowCheckedModeBanner: false,
        title: 'Catchmflixx',
        theme: CatchMFLixxTheme.theme,
        locale: locale,
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
      );
    }
  }
}
