//language provider

import 'package:catchmflixx/models/language/language.model.dart';
import 'package:catchmflixx/models/tabs/tabselector.model.dart';
import 'package:catchmflixx/state/language/language.state.dart';
import 'package:catchmflixx/state/tabs/tabs.state.dart';
import 'package:catchmflixx/state/user/details/user_details.state.dart';
import 'package:catchmflixx/state/user/login/user.login.response.state.dart';
import 'package:catchmflixx/state/user/register/register.response.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ? Language switching
final languageProvider = StateNotifierProvider<LanguageNotifier, Language>(
    (ref) => LanguageNotifier(const Language(loc: Locale("en"))));

// ? Bottom tabs switching
final tabsProvider = StateNotifierProvider<TabNotifier, TabSelector>(
    (ref) => TabNotifier(TabSelector(tab: 0)));

//login stuff
final userLoginProvider =
    StateNotifierProvider<UserLoginResponseNotifier, UserLoginResponseState>(
        (ref) => UserLoginResponseNotifier());

// register
final userRegisterProvider =
    StateNotifierProvider<RegisterResponseNotifier, RegisterResponseState>(
        (ref) => RegisterResponseNotifier());

final userDetailsProvider =
    StateNotifierProvider<UserDetailsNotifier, UserDetailsState>(
        (ref) => UserDetailsNotifier());

// final internetConnectivityProvider =
//     StateNotifierProvider<InternetCheckerNotifier, InternetStatus>(
//   (ref) {
//     final notifier = InternetCheckerNotifier();
//     notifier.updateConnection();
//     return notifier;
//   },
// );
