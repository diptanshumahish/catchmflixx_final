
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstEpNotifier extends StateNotifier<String> {
  static const _firstEp = "FIRST_EP";
  FirstEpNotifier(state) : super(state) {
    _loadFirstEp();
  }

  Future<void> saveep() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(_firstEp, state);
  }

  Future<void> _loadFirstEp() async {
    final prefs = await SharedPreferences.getInstance();
    final epSelected = prefs.getString(_firstEp);
    if (epSelected != null) {
      state = epSelected;
    }
  }

  void changeEp(String ep) {
    state = ep;
    saveep();
  }
}
