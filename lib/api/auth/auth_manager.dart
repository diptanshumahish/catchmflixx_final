// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:catchmflixx/models/error/error_model.dart';
import 'package:catchmflixx/models/user/login/user.login.response.model.dart';
import 'package:catchmflixx/models/user/maxlimit.response.model.dart';
import 'package:catchmflixx/models/user/register/register.response.model.dart';
import 'package:catchmflixx/utils/deviceinfo/device_info.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIManager {
  Dio dio = Dio(BaseOptions(
      baseUrl: "https://api.catchmflixx.com/api/user/",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: "application/json",
      headers: Map.from({
        'Accept': 'application/json',
      })));

  Future<void> addInterceptors() async {
    String agent = await returnDeviceInfo();
    Directory tempDir = await getTemporaryDirectory();
    final cookieJar = PersistCookieJar(
        storage: FileStorage(tempDir.path), ignoreExpires: true);
    dio.interceptors.add(CookieManager(cookieJar));
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      options.headers["user-agent"] = agent;
      return handler.next(options);
    }));
  }

// ✅ working as of now
  Future<UserLoginResponse> useLogin(
      String email, String password, BuildContext context, bool manual) async {
    const int statusOk = 200;
    const int statusAccepted = 202;

    UserLoginResponse user =
        UserLoginResponse(false, null, null, null, null, null, false);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool cleared = await prefs.clear();
    await addInterceptors();
    if (!cleared) {
      return user;
    }

    try {
      final response = await dio.post(
        "login",
        data: FormData.fromMap({"email_or_phone": email, "password": password}),
      );

      if (response.statusCode == statusOk) {
        user = UserLoginResponse.fromMap(response.data);

        if (user.email_is_verified == true) {
          user.isLoggedIn = true;
          user.wrongCredentials = false;
        }
      } else if (response.statusCode == statusAccepted) {
        ErrorModel error = ErrorModel.fromJson(response.data);
        ToastShow.returnToast(error.data?.message ?? "Error");
      } else {
        if (kDebugMode) {
          print("Unexpected status code: ${response.statusCode}");
        }
      }
    } on DioException catch (e) {
      if (e.response != null) {
        handleDioError(e, context);
      } else {
        // if (kDebugMode) {
        //   print(e.error);
        // }
        // if (kDebugMode) {
        //   print(e.message);
        // }
        // if (kDebugMode) {
        //   print("Network error: $e");
        // }
      }
    } catch (e) {
      if (kDebugMode) {
        print("An unexpected error occurred: $e");
      }
    }

    return user;
  }

  Future<UserLoginResponse> useGoogleLogin(
      String code, BuildContext context, bool manual) async {
    const int statusOk = 200;
    const int statusAccepted = 202;

    UserLoginResponse user =
        UserLoginResponse(false, null, null, null, null, null, false);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool cleared = await prefs.clear();
    await addInterceptors();
    if (!cleared) {
      return user;
    }

    try {
      final response = await dio.post(
        "google-auth/login-signup/",
        data: FormData.fromMap({
          "code": code,
        }),
      );

      if (response.statusCode == statusOk) {
        user = UserLoginResponse.fromMap(response.data);

        if (user.email_is_verified == true) {
          user.isLoggedIn = true;
          user.wrongCredentials = false;
        }
      } else if (response.statusCode == statusAccepted) {
        ErrorModel error = ErrorModel.fromJson(response.data);
        ToastShow.returnToast(error.data?.message ?? "Error");
      } else {
        if (kDebugMode) {
          print("Unexpected status code: ${response.statusCode}");
        }
      }
    } on DioException catch (e) {
      if (e.response != null) {
        handleDioError(e, context);
      } else {
        // if (kDebugMode) {
        //   print(e.error);
        // }
        // if (kDebugMode) {
        //   print(e.message);
        // }
        // if (kDebugMode) {
        //   print("Network error: $e");
        // }
      }
    } catch (e) {
      if (kDebugMode) {
        print("An unexpected error occurred: $e");
      }
    }

    return user;
  }

  Future<UserLoginResponse> useManualLogin(
      String id, BuildContext context, bool manual) async {
    await addInterceptors();
    const int statusOk = 200;
    const int statusLocked = 423;
    const int statusAccepted = 202;

    UserLoginResponse user =
        UserLoginResponse(false, null, null, null, null, null, false);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool cleared = await prefs.clear();

    if (!cleared) {
      return user;
    }

    try {
      final response = await dio.post(
        "manual-logout",
        data: FormData.fromMap({"id": id}),
      );

      if (response.statusCode == statusOk) {
        user = UserLoginResponse.fromMap(response.data);

        if (user.email_is_verified == true) {
          user.isLoggedIn = true;
          user.wrongCredentials = false;
        }
      } else if (response.statusCode == statusLocked) {
        if (kDebugMode) {
          print("Account is locked");
        }
      } else if (response.statusCode == statusAccepted) {
        ErrorModel error = ErrorModel.fromJson(response.data);
        ToastShow.returnToast(error.data?.message ?? "Error");
      } else {
        if (kDebugMode) {
          print("Unexpected status code: ${response.statusCode}");
        }
      }
    } on DioException catch (e) {
      if (e.response != null) {
        handleDioError(e, context);
      } else {
        if (kDebugMode) {
          print("Network error: $e");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("An unexpected error occurred: $e");
      }
    }

    return user;
  }

  void handleDioError(DioException e, BuildContext context) async {
    const int statusBadRequest = 400;
    const int statusLocked = 423;

    if (e.response?.statusCode == statusBadRequest) {
      ErrorModel error = ErrorModel.fromJson(e.response?.data);
      ToastShow.returnToast(error.data?.message ?? "Error");
    } else if (e.response?.statusCode == statusLocked) {
      navigateToPage(
        context,
        '/max-login/',
        data: MaxLimit.fromJson(e.response?.data),
        isReplacement: true,
      );
    } else {
      if (kDebugMode) {
        print(
            "Unhandled error: ${e.response?.statusCode} - ${e.response?.data}");
      }
    }
  }

  Future<int> useLogout() async {
    await addInterceptors();
    int res = 0;

    try {
      final response = await dio.post("logout");

      if (response.statusCode == 204) {
        res = 200;
      } else {
        res = 400;
      }
    } catch (e) {
      res = 400;
    }

    return res;
  }

  Future<void> refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await addInterceptors();
    try {
      final response = await dio.post("refresh");
      print('😁');
      print(response.data);
      print('😁');
      print(response.statusMessage);
      if (response.statusCode == 201) {
        prefs.setString("bearer", response.data["data"]["access"]);
      } else if (response.statusCode == 401) {
        final api = APIManager();
        await api.useLogout();
        Restart.restartApp();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<RegisterResponse> useRegister(
      String email,
      String phone_number,
      String name,
      int pincode,
      String city,
      String password,
      String password2,
      String dob) async {
    RegisterResponse res = RegisterResponse(data: null, success: false);
    try {
      final response = await dio.post("register",
          data: FormData.fromMap({
            "email": email,
            "phone_number": phone_number,
            "name": name,
            "pincode": pincode,
            "city": city,
            "password": password,
            "password2": password2,
          }));

      if (response.statusCode == 201) {
        res = RegisterResponse.fromMap(response.data);
      } else {
        ErrorModel error = ErrorModel.fromJson(response.data);
        ToastShow.returnToast(error.data?.message ??
            "There is some issue at the server, try again ");
      }
    } on DioException catch (e) {
      ErrorModel error = ErrorModel.fromJson(e.response?.data);
      ToastShow.returnToast(error.data?.message ?? "Error");
    }

    return res;
  }
}
