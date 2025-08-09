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
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          contentType: "application/json",
          headers: {
            'Accept': 'application/json',
          },
        )),
        secondaryDio = Dio(BaseOptions(
          baseUrl: "https://www.catchmflixx.com/api/",
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          contentType: "application/json",
          headers: {
            'Accept': 'application/json',
          },
        ));

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

  Future<void> init() async {
    // print("initialising interceptors");
    await addInterceptors();
  }

  Future<String> getLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lang = prefs.getString("APP_LANG") ?? "en";
    return lang;
  }

  Future<T?> makeRequest<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson, {
    String method = 'GET',
    FormData? data,
    bool useSecondaryDio = false,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      APIManager api = APIManager();

      Dio dioInstance = useSecondaryDio ? secondaryDio : mainDio;
      await addInterceptors();

      Future<Response> makeApiCall(String token) async {
        final headers = token.isEmpty
            ? <String, String>{}
            : {'Authorization': 'Bearer $token'};
        final options = Options(
          headers: headers,
          validateStatus: (status) => true,
        );

        switch (method.toUpperCase()) {
          case 'POST':
            return await dioInstance.post(endpoint,
                data: data, options: options);
          case 'PUT':
            return await dioInstance.put(endpoint,
                data: data, options: options);
          case 'PATCH':
            return await dioInstance.patch(endpoint,
                data: data, options: options);
          case 'DELETE':
            return await dioInstance.delete(endpoint,
                data: data, options: options);
          case 'GET':
          default:
            return await dioInstance.get(endpoint, options: options);
        }
      }

      String? bearerToken = prefs.getString("bearer");
      Response res = await makeApiCall(bearerToken ?? '');

      if (res.statusCode == 200 || res.statusCode == 201) {
        return fromJson(res.data);
      } else if (res.statusCode == 401) {
        await api.refreshToken();
        bearerToken = prefs.getString("bearer");
        res = await makeApiCall(bearerToken ?? '');

        if (res.statusCode == 200 || res.statusCode == 201) {
          return fromJson(res.data);
        } else {
          _handleErrorResponse(res);
          return null;
        }
      } else {
        _handleErrorResponse(res);
        return null;
      }
    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    } catch (e) {
      ToastShow.returnToast("An unexpected error occurred");
      // print("Network error: $e");
      return null;
    }
  }

  void _handleErrorResponse(Response response) {
    String errorMessage = "Unknown error occurred";

    try {
      if (response.data != null && response.data is Map<String, dynamic>) {
        MessageModel msg = MessageModel.fromJson(response.data);
        errorMessage = msg.data?.message ?? "Error ${response.statusCode}";
      } else if (response.statusMessage != null) {
        errorMessage = response.statusMessage!;
      }
    } catch (_) {
      errorMessage = "Error ${response.statusCode}";
    }

    if (errorMessage != "No Content" &&
        errorMessage != "Internal Server Error") {
      ToastShow.returnToast(errorMessage);
    }
  }

  void _handleDioError(DioException e) {
    String errorMessage;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = "Connection timed out. Please check your internet.";
        break;
      case DioExceptionType.badCertificate:
        errorMessage = "Invalid SSL certificate. Please contact support.";
        break;
      case DioExceptionType.connectionError:
        errorMessage = "Connection error. Please check your internet.";
        break;
      case DioExceptionType.badResponse:
        if (e.response?.data != null &&
            e.response!.data is Map<String, dynamic>) {
          try {
            MessageModel msg = MessageModel.fromJson(e.response!.data);
            errorMessage = msg.data?.message ?? "Server error";
          } catch (_) {
            errorMessage = "Server error (${e.response?.statusCode})";
          }
        } else {
          errorMessage = "Server error (${e.response?.statusCode})";
        }
        break;
      case DioExceptionType.cancel:
        errorMessage = "Request was cancelled";
        break;
      default:
        errorMessage = "Network error occurred";
    }
    if (errorMessage != "No Content" ||
        errorMessage != "Internal server error") {
      ToastShow.returnToast(errorMessage);
    }
  }
}
