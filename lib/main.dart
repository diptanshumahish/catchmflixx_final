import 'dart:io' show Platform; // Import Platform to check the operating system
import 'package:catchmflixx/firebase_options.dart';
import 'package:catchmflixx/screens/start/splash_screen.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/theme/theme_catchmflixx.dart';
import 'package:catchmflixx/utils/firebase/firebase_api.dart';
import 'package:catchmflixx/utils/go_router/go.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //setup 120hz refresh rate.
  await FlutterDisplayMode.setHighRefreshRate();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
  await ScreenProtector.protectDataLeakageOn();
  if (Platform.isIOS) {
    await ScreenProtector.protectDataLeakageWithColor(Colors.black);
  }
  runApp(const ProviderScope(child: CatchMFlixxApp()));
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
      return CupertinoApp(
        debugShowCheckedModeBanner: false,
        title: 'Catchmflixx',
        theme: const CupertinoThemeData(
          primaryColor: CupertinoColors.activeBlue,
        ),
        locale: locale,
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
        home: const SplashScreen(),
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
