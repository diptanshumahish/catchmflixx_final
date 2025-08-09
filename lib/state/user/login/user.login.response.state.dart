import 'dart:convert';
import 'package:catchmflixx/api/auth/auth_manager.dart';
import 'package:catchmflixx/models/user/login/user.login.response.model.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


@immutable
abstract class UserLoginResponseState {}

class InitialUserLoginResponseState extends UserLoginResponseState {}

class LoadingUserLoginResponseState extends UserLoginResponseState {}

class LoadedUserLoginResponseState extends UserLoginResponseState {
  final UserLoginResponse userLoginResponse;

  LoadedUserLoginResponseState({required this.userLoginResponse});
}

class ErrorUserLoginResponseState extends UserLoginResponseState {
  final String message;
  ErrorUserLoginResponseState({required this.message});
}

class UserLoginResponseNotifier extends StateNotifier<UserLoginResponseState> {
  UserLoginResponseNotifier() : super(InitialUserLoginResponseState()) {
    loadUser();
  }
  static const _userLoginResponseKey = "USER_LOGIN_RESPONSE";
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userResponse = prefs.getString(_userLoginResponseKey);

    if (userResponse != null) {
      state = LoadedUserLoginResponseState(
          userLoginResponse:
              UserLoginResponse.fromMap(jsonDecode(userResponse)));
    } else {
      state = LoadedUserLoginResponseState(
          userLoginResponse:
              UserLoginResponse(true, null, null, false, false, null, false));
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userLoginResponseKey);
    await prefs.remove("bearer");
    await prefs.remove("refresh_token");
    state = InitialUserLoginResponseState();
  }

  Future<void> saveUserLoginResponse() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    if (state is LoadedUserLoginResponseState) {
      final userLoginResponse =
          (state as LoadedUserLoginResponseState).userLoginResponse;
      final dataToSave = jsonEncode(userLoginResponse.toMap());
      sp.setString(_userLoginResponseKey, dataToSave);
    } else {
      sp.remove(_userLoginResponseKey);
    }
  }

  Future<int> makeLogin(String emailOrPhone, String password, BuildContext ctx,
      bool manual) async {
    APIManager api = APIManager();
    try {
      state = LoadingUserLoginResponseState();
      UserLoginResponse user =
          await api.useLogin(emailOrPhone, password, ctx, manual);
      state = LoadedUserLoginResponseState(userLoginResponse: user);
      saveUserLoginResponse();
      if (user.success == true) {
        if (user.email_is_verified == true) {
          return 200;
        } else {
          ToastShow.returnToast("Email not verified!");
          return 500;
        }
      } else {
        return 400;
      }
    } catch (e) {
      state = ErrorUserLoginResponseState(message: e.toString());
      return 400;
    }
  }

  Future<int> makeGoogleLogin(
      String idToken, String accessToken, BuildContext ctx, bool manual) async {
    APIManager api = APIManager();
    try {
      state = LoadingUserLoginResponseState();
      UserLoginResponse user =
          await api.useGoogleLogin(idToken, accessToken, ctx, manual);
      state = LoadedUserLoginResponseState(userLoginResponse: user);
      saveUserLoginResponse();
      if (user.success == true) {
        if (user.email_is_verified == true) {
          return 200;
        } else {
          ToastShow.returnToast("Email not verified!");
          return 500;
        }
      } else {
        return 400;
      }
    } catch (e) {
      state = ErrorUserLoginResponseState(message: e.toString());
      return 400;
    }
  }

  Future<int> makeManualLogin(String id, BuildContext ctx, bool manual) async {
    APIManager api = APIManager();
    try {
      state = LoadingUserLoginResponseState();
      UserLoginResponse user = await api.useManualLogin(id, ctx, manual);
      state = LoadedUserLoginResponseState(userLoginResponse: user);
      saveUserLoginResponse();
      if (user.success == true) {
        if (user.email_is_verified == true) {
          return 200;
        } else {
          ToastShow.returnToast("Email not verified!");
          return 500;
        }
      } else {
        return 400;
      }
    } catch (e) {
      state = ErrorUserLoginResponseState(message: e.toString());
      return 400;
    }
  }
}
