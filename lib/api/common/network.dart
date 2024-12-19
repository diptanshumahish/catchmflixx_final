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
  final Dio mainDio;
  final Dio secondaryDio;
  PersistCookieJar? cookieJar;

  NetworkManager()
      : mainDio = Dio(BaseOptions(
          baseUrl: "https://api.catchmflixx.com/api/",
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          contentType: "application/json",
          headers: {
            'Accept': 'application/json',
          },
        )),
        secondaryDio = Dio(BaseOptions(
          baseUrl: "https://www.catchmflixx.com/api/",
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
    Directory tempDir = await getApplicationCacheDirectory();
    cookieJar = PersistCookieJar(
        storage: FileStorage(tempDir.path), ignoreExpires: true);

    String agent = await returnDeviceInfo();

    mainDio.interceptors.add(CookieManager(cookieJar!));
    secondaryDio.interceptors.add(CookieManager(cookieJar!));

    final requestInterceptor =
        InterceptorsWrapper(onRequest: (options, handler) {
      options.headers["user-agent"] = agent;
      return handler.next(options);
    });

    mainDio.interceptors.add(requestInterceptor);
    secondaryDio.interceptors.add(requestInterceptor);
  }

  Future<T> makeRequest<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson, {
    String method = 'GET',
    FormData? data,
    bool useSecondaryDio = false,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    APIManager api = APIManager();

    Dio dioInstance = useSecondaryDio ? secondaryDio : mainDio;

    await addInterceptors();

    Future<Response> makeApiCall(String token) async {
      final headers = token.isEmpty
          ? <String, String>{}
          : {'Authorization': 'Bearer $token'};
      switch (method.toUpperCase()) {
        case 'POST':
          return await dioInstance.post(endpoint,
              data: data, options: Options(headers: headers));
        case 'PUT':
          return await dioInstance.put(endpoint,
              data: data, options: Options(headers: headers));
        case 'PATCH':
          return await dioInstance.patch(endpoint,
              data: data, options: Options(headers: headers));
        case 'DELETE':
          return await dioInstance.delete(endpoint,
              data: data, options: Options(headers: headers));
        case 'GET':
        default:
          return await dioInstance.get(endpoint,
              options: Options(headers: headers));
      }
    }

    try {
      String? bearerToken = prefs.getString("bearer");
      Response res = await makeApiCall(bearerToken ?? '');

      switch (res.statusCode) {
        case 200:
        case 201:
          return fromJson(res.data);
        case 401:
          break;
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
      if (e.response?.statusCode == 401) {
        await api.refreshToken();
        String? bearerToken = prefs.getString("bearer");
        Response res = await makeApiCall(bearerToken ?? '');

        bearerToken = prefs.getString("bearer");
        res = await makeApiCall(bearerToken ?? '');
        if (res.statusCode == 200 || res.statusCode == 201) {
          return fromJson(res.data);
        }
      }
      MessageModel msg = MessageModel.fromJson(e.response?.data);
      ToastShow.returnToast(msg.data?.message ?? "Error");
      throw Exception(e.message ?? "Error occurred");
    } catch (e) {
      // ToastShow.returnToast(e.toString());
      throw Exception(e.toString());
    }

    throw Exception("Unhandled error occurred");
  }
}
