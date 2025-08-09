import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:catchmflixx/theme/theme_catchmflixx.dart';
import 'package:catchmflixx/utils/go_router/go.dart';

class AppConfig {
  static const List<Locale> supportedLocales = [
    Locale("en"),
    Locale("hi"),
    Locale("kn"),
    Locale("ml"),
    Locale("te"),
    Locale("ta"),
  ];

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static Locale? validateLocale(Locale? locale) {
    if (locale == null) return null;
    
    final isSupported = supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    );
    
    if (!isSupported) {
      debugPrint('Unsupported locale detected: ${locale.languageCode}. Falling back to English.');
      return const Locale("en");
    }
    
    return locale;
  }

  static Widget buildApp(Locale? locale) {
    final validatedLocale = validateLocale(locale);

    if (Platform.isIOS) {
      return CupertinoApp.router(
        routerConfig: appRoute,
        debugShowCheckedModeBanner: false,
        title: 'Catchmflixx',
        theme: CatchMFLixxThemeIOS.theme,
        locale: validatedLocale,
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
      );
    } else {
      return MaterialApp.router(
        routerConfig: appRoute,
        debugShowCheckedModeBanner: false,
        title: 'Catchmflixx',
        theme: CatchMFLixxTheme.theme,
        locale: validatedLocale,
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
      );
    }
  }

  static Widget buildFallbackApp() {
    if (Platform.isIOS) {
      return CupertinoApp.router(
        routerConfig: appRoute,
        debugShowCheckedModeBanner: false,
        title: 'Catchmflixx',
        theme: CatchMFLixxThemeIOS.theme,
        locale: const Locale("en"),
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
      );
    } else {
      return MaterialApp.router(
        routerConfig: appRoute,
        debugShowCheckedModeBanner: false,
        title: 'Catchmflixx',
        theme: CatchMFLixxTheme.theme,
        locale: const Locale("en"),
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
      );
    }
  }
}
