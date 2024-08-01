import 'package:catchmflixx/api/user/profile/profile_api.dart';
import 'package:catchmflixx/api/user/user_activity/user.activity.dart';
import 'package:catchmflixx/api/user/user_activity/watch_history_list.model.dart';
import 'package:catchmflixx/api/user/user_activity/watch_later_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<UserActivityHistory> getStaticWatchHistory() async {
  UserActivity ua = UserActivity();
  return await ua.getWatchHistory();
}

class UserWatchHistoryNotifier extends StateNotifier<UserActivityHistory> {
  UserWatchHistoryNotifier() : super(UserActivityHistory()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    UserActivityHistory data = await getStaticWatchHistory();
    state = data;
  }

  Future<void> updateState() async {
    UserActivity ua = UserActivity();
    UserActivityHistory data = await ua.getWatchHistory();
    state = data;
  }
}

Future<WatchLaterList> getStaticWatchLater() async {
  ProfileApi p = ProfileApi();

  return await p.getWatchLater();
}

class UserWatchLaterNotifier extends StateNotifier<WatchLaterList> {
  UserWatchLaterNotifier() : super(WatchLaterList()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    WatchLaterList data = await getStaticWatchLater();
    state = data;
  }

  Future<void> updateState() async {
    state = await getStaticWatchLater();
  }
}
