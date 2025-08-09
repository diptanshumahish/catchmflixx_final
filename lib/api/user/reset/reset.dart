import 'package:catchmflixx/api/common/network.dart';
import 'package:catchmflixx/models/user/reset/reset_sent.model.dart';
import 'package:dio/dio.dart';

class ResetPassword {
  NetworkManager networkManager = NetworkManager();

  Future<ResetSent?> addResetSent(
    String email,
  ) async {
    final FormData data = FormData.fromMap({
      "email_or_mobile": email,
    });
    return await networkManager.makeRequest<ResetSent>(
        "user/request-reset-email/", (p0) => ResetSent.fromJson(p0),
        method: "POST", data: data);
  }
}
