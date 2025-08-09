import 'package:catchmflixx/api/common/network.dart';
import 'package:catchmflixx/api/user/user_activity/watch_history_list.model.dart';
import 'package:catchmflixx/api/user/user_activity/watch_progress.model.dart';
import 'package:catchmflixx/models/user/login/google.login.step.one.model.dart';
import 'package:dio/dio.dart';

class UserActivity {
  NetworkManager networkManager = NetworkManager();



  Future<GoogleLoginStepOneResponse?> googleLoginStepOne() async {
    return await networkManager.makeRequest<GoogleLoginStepOneResponse>(
        "user/google-auth/redirect/",
        (p0) => GoogleLoginStepOneResponse.fromJson(p0),
        method: "GET",
      );
  }

  Future<WatchProgress?> addWatchProgress(String id, int progress) async {
    final FormData data = FormData.fromMap(
        {"video_id": id, "progress_seconds": progress.toString()});
    return await networkManager.makeRequest<WatchProgress>(
        "content/update-watch-progress", (p0) => WatchProgress.fromJson(p0),
        method: "POST", data: data);
  }

  Future<WatchProgress?> acknowledgeAd(String id) async {
    final FormData data = FormData.fromMap({
      "uuid": id,
    });
    return await networkManager.makeRequest<WatchProgress>(
        "content/vid-ad-acknowledge/", (p0) => WatchProgress.fromJson(p0),
        method: "POST", data: data);
  }

  Future<UserActivityHistory?> getWatchHistory() async {
    return await networkManager.makeRequest<UserActivityHistory>(
        "content/watched-list", (p0) => UserActivityHistory.fromJson(p0));
  }
}
