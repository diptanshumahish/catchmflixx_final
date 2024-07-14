import 'package:catchmflixx/firebase_options.dart';
import 'package:catchmflixx/screens/start/splash_screen.dart';
import 'package:catchmflixx/theme/theme_catchmflixx.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ScreenProtector.protectDataLeakageOn();
  runApp(const ProviderScope(child: CatchMFlixxApp()));
}

class CatchMFlixxApp extends StatelessWidget {
  const CatchMFlixxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catchmflixx',
      theme: CatchMFLixxTheme.theme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      home: const SplashScreen(),
      supportedLocales: const [
        Locale("en"),
        Locale("hi"),
        Locale("kn"),
        Locale("ml"),
        Locale("te"),
        Locale("ta")
      ],
    );
  }
}
