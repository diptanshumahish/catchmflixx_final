import 'dart:io';

import 'package:catchmflixx/api/auth/auth_manager.dart';
import 'package:catchmflixx/models/message/message_model.dart';
import 'package:catchmflixx/utils/deviceinfo/device_info.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkManager {
  Dio dio;

  NetworkManager()
      : dio = Dio(BaseOptions(
          baseUrl: "https://api.catchmflixx.com/api/",
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          contentType: "application/json",
          headers: {
            'Accept': 'application/json',
          },
        ));

  Future<void> init() async {
    await addInterceptors();
  }

  Future<String> getLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lang = prefs.getString("APP_LANG") ?? "en";
    return lang;
  }

  Future<void> addInterceptors() async {
    APIManager api = APIManager();
    await api.refreshToken();
    Directory tempDir = await getApplicationCacheDirectory();
    final cookieJar = PersistCookieJar(
        storage: FileStorage(tempDir.path), ignoreExpires: true);

    String agent = await returnDeviceInfo();

    dio.interceptors.add(CookieManager(cookieJar));

    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      options.headers["user-agent"] = agent;
      return handler.next(options);
    }));
  }

  Future<T> makeRequest<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson, {
    String method = 'GET',
    FormData? data,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await init();
    final bearerToken = prefs.getString("bearer");
    final String? isNotVerified = prefs.getString("temp_login_mail");
    final headers = isNotVerified != null
        ? <String, String>{}
        : {'Authorization': 'Bearer $bearerToken'};

    try {
      Response res;
      switch (method.toUpperCase()) {
        case 'POST':
          res = await dio.post(endpoint,
              data: data, options: Options(headers: headers));
          break;
        case 'PUT':
          res = await dio.put(endpoint,
              data: data, options: Options(headers: headers));
          break;
        case 'PATCH':
          res = await dio.patch(endpoint,
              data: data, options: Options(headers: headers));
          break;
        case 'DELETE':
          res = await dio.delete(endpoint,
              data: data, options: Options(headers: headers));
          break;
        case 'GET':
        default:
          res = await dio.get(endpoint, options: Options(headers: headers));
          break;
      }

      switch (res.statusCode) {
        case 200:
          return fromJson(res.data);
        case 201:
          return fromJson(res.data);
        case 401:
          ToastShow.returnToast("Session expired, login again");
          throw Exception("Unauthorized: ${res.data['message']}");
        case 403:
          throw Exception("Forbidden: ${res.data['message']}");
        case 404:
          throw Exception("Not found: ${res.data['message']}");
        case 423:
          MessageModel msg = MessageModel.fromJson(res.data);
          ToastShow.returnToast(msg.data?.message ?? "Error");
          throw Exception("Locked: ${res.data['message']}");

        case 500:
          throw Exception("Internal server error: ${res.data['message']}");
        default:
          throw Exception("Error: ${res.data['message']}");
      }
    } on DioException catch (e) {
      MessageModel msg = MessageModel.fromJson(e.response?.data);
      ToastShow.returnToast(msg.data?.message ?? "Error");
      throw Exception(e.message ?? "Error occurred");
    } catch (e) {
      ToastShow.returnToast(e.toString());
      throw Exception(e.toString());
    }
  }
}
