// !✅ Will be used when the case arises, of maximum sessions exceeded.
// ? This way users can log in at the current session by destroying the previous session.

class MaxLimit {
  bool? success;
  Data? data;

  MaxLimit({this.success, this.data});

  MaxLimit.fromJson(Map<String, dynamic> json) {
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
  List<Sessions>? sessions;
  String? message;

  Data({this.sessions, this.message});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['sessions'] != null) {
      sessions = <Sessions>[];
      json['sessions'].forEach((v) {
        sessions!.add(Sessions.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sessions != null) {
      data['sessions'] = sessions!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class Sessions {
  int? id;
  String? user;
  String? userAgent;
  String? lastLogin;

  Sessions({this.id, this.user, this.userAgent, this.lastLogin});

  Sessions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    userAgent = json['user_agent'];
    lastLogin = json['last_login'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user'] = user;
    data['user_agent'] = userAgent;
    data['last_login'] = lastLogin;
    return data;
  }
}
