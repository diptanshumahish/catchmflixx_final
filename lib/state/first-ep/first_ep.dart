import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; 

class FirstEpNotifier extends StateNotifier<List<String>> {
  static const _firstEp = "FIRST_EP";

  FirstEpNotifier() : super(["", ""]) {
    _loadFirstEp();
  }

  Future<void> saveEp() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(_firstEp, jsonEncode(state));
  }

  Future<void> _loadFirstEp() async {
    final prefs = await SharedPreferences.getInstance();
    final epSelected = prefs.getString(_firstEp);
    if (epSelected != null) {
      state = List<String>.from(jsonDecode(epSelected));
    }
  }

  void changeEp(String ep) {
    if (state.length >= 2) {
      state.removeAt(0);
    }
    state.add(ep);
    saveEp();
  }

  void putAtFirstIndex(String ep) {
    if (state.isEmpty) {
      state = ["", ""];
    }
    state[0] = ep;
    saveEp();
  }

  void putAtSecondIndex(String ep) {
    if (state.isEmpty) {
      state = ["", ""];
    } else if (state.length == 1) {
      state.add(""); 
    }
    state[1] = ep;
    saveEp();
  }
}
