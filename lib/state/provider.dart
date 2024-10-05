//language provider

import 'package:catchmflixx/api/user/user_activity/watch_history_list.model.dart';
import 'package:catchmflixx/api/user/user_activity/watch_later_list.dart';
import 'package:catchmflixx/models/language/language.model.dart' as lang;
import 'package:catchmflixx/models/tabs/tabselector.model.dart';
import 'package:catchmflixx/state/first-ep/first_ep.dart';
import 'package:catchmflixx/state/language/language.state.dart';
import 'package:catchmflixx/state/tabs/tabs.state.dart';
import 'package:catchmflixx/state/user/activity/user_activity.dart';
import 'package:catchmflixx/state/user/details/user_details.state.dart';
import 'package:catchmflixx/state/user/login/user.login.response.state.dart';
import 'package:catchmflixx/state/user/register/register.response.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ? Language switching
final languageProvider = StateNotifierProvider<LanguageNotifier, lang.Language>(
    (ref) => LanguageNotifier(const lang.Language(loc: Locale("en"))));

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

final watchHistoryProvider =
    StateNotifierProvider<UserWatchHistoryNotifier, UserActivityHistory>(
        (ref) => UserWatchHistoryNotifier());
final watchLaterProvider =
    StateNotifierProvider<UserWatchLaterNotifier, WatchLaterList>(
        (ref) => UserWatchLaterNotifier());

final firstEpProvider =
    StateNotifierProvider<FirstEpNotifier, List<String>>(
        (ref) => FirstEpNotifier());


// final internetConnectivityProvider =
//     StateNotifierProvider<InternetCheckerNotifier, InternetStatus>(
//   (ref) {
//     final notifier = InternetCheckerNotifier();
//     notifier.updateConnection();
//     return notifier;
//   },
// );
