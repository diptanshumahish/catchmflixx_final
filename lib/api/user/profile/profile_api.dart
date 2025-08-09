import 'package:catchmflixx/api/common/network.dart';
import 'package:catchmflixx/api/user/profile/profile_response_model.dart';
import 'package:catchmflixx/api/user/user_activity/watch_later.model.dart';
import 'package:catchmflixx/api/user/user_activity/watch_later_list.dart';
import 'package:catchmflixx/models/message/message_model.dart';
import 'package:catchmflixx/models/profiles/avatar_list.model.dart';
import 'package:catchmflixx/models/profiles/logged_in_current_profile.model.dart';
import 'package:catchmflixx/models/profiles/profile.model.dart';
import 'package:catchmflixx/models/profiles/profile_creation_sucess.model.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:dio/dio.dart';

class ProfileApi {
  final NetworkManager networkManager = NetworkManager();

  Future<ProfileLoginResponse?> useProfileLogin(
      String hash, String? password) async {
    final data = FormData.fromMap({"hash": hash, "password": password ?? ""});
    return await networkManager.makeRequest<ProfileLoginResponse>(
        "user/profile-login", (data) => ProfileLoginResponse.fromJson(data),
        data: data, method: "POST");
  }

  Future<MessageModel?> resetProfilePassword(
    String hash,
  ) async {
    final data = FormData.fromMap({
      "uuid": hash,
    });
    return await networkManager.makeRequest<MessageModel>(
        "user/request-reset-profile", (data) => MessageModel.fromJson(data),
        data: data, method: "POST");
  }

  Future<ProfileCreationResponse?> addProfile(
      String name, String? password, ProfileType type, String? avatar) async {
    final data = FormData.fromMap({
      "name": name,
      "profile_type": type == ProfileType.Adult ? "Adult" : "Kids",
      "avatar": avatar,
      "password":
          password != null && password.isNotEmpty ? int.parse(password) : null
    });

    return await networkManager.makeRequest<ProfileCreationResponse>(
        "user/profiles/", (data) => ProfileCreationResponse.fromJson(data),
        data: data, method: "POST");
  }

  Future<MessageModel?> deleteProfile(String profileId) async {
    return await networkManager.makeRequest<MessageModel>(
        "user/del-edit-profile/$profileId",
        (data) => MessageModel.fromJson(data),
        method: "DELETE");
  }

  Future<ProfilesList?> fetchProfiles() async {
    try {
      return await networkManager.makeRequest<ProfilesList>(
        "user/profiles",
        (data) => ProfilesList.fromMap(data),
      );
    } catch (e) {
      return ProfilesList(data: [], success: false);
    }
  }

  Future<MessageModel?> editProfile(String profileId, String? name,
      int avatarId, String? pin, bool changepin) async {
    var data = FormData();
    if (changepin) {
      data = FormData.fromMap({
        "name": name,
        "avatar_id": avatarId,
        "password": (pin == null || pin.isEmpty) ? "" : int.parse(pin)
      });
    } else {
      data = FormData.fromMap({
        "name": name,
        "avatar_id": avatarId,
      });
    }

    return await networkManager.makeRequest<MessageModel>(
        "user/del-edit-profile/$profileId",
        (data) => MessageModel.fromJson(data),
        data: data,
        method: "PUT");
  }

  Future<AvatarList?> getAvatars() async {
    try {
      return await networkManager.makeRequest<AvatarList>(
          "user/get-avatar", (data) => AvatarList.fromJson(data),
          method: "GET");
    } catch (e) {
      return AvatarList(data: [], success: false);
    }
  }

  Future<void> addToWatchLater(String id) async {
    final data = FormData.fromMap({"uuid_or_suuid": id});
    try {
      final response = await networkManager.makeRequest<AddedToWatchLater>(
          "user/watch-later/", (data) => AddedToWatchLater.fromJson(data),
          data: data, method: "POST");

      ToastShow.returnToast(response?.message ?? "");
    } catch (e) {
      ToastShow.returnToast("Error adding to watch later");
    }
  }

  Future<void> removeFromWatchLater(String id) async {
    final data = FormData.fromMap({"uuid_or_suuid": id});
    try {
      final response = await networkManager.makeRequest<AddedToWatchLater>(
          "user/watch-later/", (data) => AddedToWatchLater.fromJson(data),
          data: data, method: "DELETE");

      ToastShow.returnToast(response?.message ?? "");
    } catch (e) {
      ToastShow.returnToast("Error removing from watch later");
    }
  }

  Future<WatchLaterList?> getWatchLater() async {
    try {
      return await networkManager.makeRequest<WatchLaterList>(
          "user/watch-later/", (data) => WatchLaterList.fromJson(data),
          method: "GET");
    } catch (e) {
      return WatchLaterList(data: [], success: false);
    }
  }

  Future<LoggedInCurrentProfile?> getCurrentProfile() async {
    return await networkManager.makeRequest<LoggedInCurrentProfile>(
        "user/get-profile/", (data) => LoggedInCurrentProfile.fromJson(data));
  }
}

enum ProfileType { Adult, Kids }
