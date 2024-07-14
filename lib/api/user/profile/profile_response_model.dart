class ProfileLoginResponse {
  bool? success;
  Data? data;

  ProfileLoginResponse({this.success, this.data});

  ProfileLoginResponse.fromJson(Map<String, dynamic> json) {
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
  String? message;
  String? name;
  String? profileType;

  Data({this.message, this.name, this.profileType});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    name = json['name'];
    profileType = json['profile_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['name'] = name;
    data['profile_type'] = profileType;
    return data;
  }
}
