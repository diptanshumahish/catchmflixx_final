import 'dart:ui';

import 'package:catchmflixx/models/language/language.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageNotifier extends StateNotifier<Language> {
  static const _langKey = "APP_LANG";
  LanguageNotifier(state) : super(state) {
    _loadLangSelected();
  }

  Future<void> saveLang() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(_langKey, state.loc.languageCode);
  }

  Future<void> _loadLangSelected() async {
    final prefs = await SharedPreferences.getInstance();
    final langSelected = prefs.getString(_langKey);
    if (langSelected != null) {
      state = Language(loc: Locale(langSelected));
    }
  }

  void switchLanguage(Locale lang) {
    state = state.copyWith(loc: lang);
    saveLang();
  }
}
