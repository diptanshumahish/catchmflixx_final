class GoogleLoginStepOneResponse {
  bool? success;
  Data? data;

  GoogleLoginStepOneResponse({this.success, this.data});

  GoogleLoginStepOneResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? authorizationUrl;

  Data({this.authorizationUrl});

  Data.fromJson(Map<String, dynamic> json) {
    authorizationUrl = json['authorization_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['authorization_url'] = authorizationUrl;
    return data;
  }
}
