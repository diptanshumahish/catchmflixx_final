import 'dart:convert';

import 'package:catchmflixx/models/user/details/user_details.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserDetailsState {}

class Init extends UserDetailsState {}

class Loading extends UserDetailsState {}

class Loaded extends UserDetailsState {
  final UserDetails user;

  Loaded({required this.user});
}

class Error extends UserDetailsState {
  final String msg;

  Error({required this.msg});
}

class UserDetailsNotifier extends StateNotifier<UserDetailsState> {
  UserDetailsNotifier() : super(Init()) {
    loadUserDetails();
  }

  static const _userDetailsKey = "USER_DETAILS";

  Future<void> loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final userResponse = prefs.getString(_userDetailsKey);
    if (userResponse != null) {
      state = Loaded(user: UserDetails.fromMap(jsonDecode(userResponse)));
    } else {
      state = Loaded(user: UserDetails(false, null));
    }
  }

  Future<void> updateDetails(UserDetails user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDetailsKey, user.toString());
    state = Loaded(user: user);
  }
}
