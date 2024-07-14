import 'dart:convert';

class UserLoginResponse {
  bool? success;
  Data? data;
  String? name;
  bool? email_is_verified;
  bool? wrongCredentials;
  String? responseCode;
  bool? isLoggedIn;

  UserLoginResponse(
    this.success,
    this.data,
    this.name,
    this.email_is_verified,
    this.wrongCredentials,
    this.responseCode,
    this.isLoggedIn,
  );

  UserLoginResponse copyWith({
    bool? success,
    Data? data,
    String? name,
    bool? email_is_verified,
    bool? wrongCredentials,
    String? responseCode,
    bool? isLoggedIn,
  }) {
    return UserLoginResponse(
      success ?? this.success,
      data ?? this.data,
      name ?? this.name,
      email_is_verified ?? this.email_is_verified,
      wrongCredentials ?? this.wrongCredentials,
      responseCode ?? this.responseCode,
      isLoggedIn ?? this.isLoggedIn,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'data': data?.toMap(),
      'name': name,
      'email_is_verified': email_is_verified,
      'wrongCredentials': wrongCredentials,
      'responseCode': responseCode,
      'isLoggedIn': isLoggedIn,
    };
  }

  factory UserLoginResponse.fromMap(Map<String, dynamic> map) {
    return UserLoginResponse(
      map['success'] != null ? map['success'] as bool : null,
      map['data'] != null
          ? Data.fromMap(map['data'] as Map<String, dynamic>)
          : null,
      map['name'] != null ? map['name'] as String : null,
      map['email_is_verified'] != null
          ? map['email_is_verified'] as bool
          : null,
      map['wrongCredentials'] != null ? map['wrongCredentials'] as bool : null,
      map['responseCode'] != null ? map['responseCode'] as String : null,
      map['isLoggedIn'] != null ? map['isLoggedIn'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserLoginResponse.fromJson(String source) =>
      UserLoginResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserLoginResponse(success: $success, data: $data, name: $name, email_is_verified: $email_is_verified, wrongCredentials: $wrongCredentials, responseCode: $responseCode, isLoggedIn: $isLoggedIn)';
  }

  @override
  bool operator ==(covariant UserLoginResponse other) {
    if (identical(this, other)) return true;

    return other.success == success &&
        other.data == data &&
        other.name == name &&
        other.email_is_verified == email_is_verified &&
        other.wrongCredentials == wrongCredentials &&
        other.responseCode == responseCode &&
        other.isLoggedIn == isLoggedIn;
  }

  @override
  int get hashCode {
    return success.hashCode ^
        data.hashCode ^
        name.hashCode ^
        email_is_verified.hashCode ^
        wrongCredentials.hashCode ^
        responseCode.hashCode ^
        isLoggedIn.hashCode;
  }
}

class Data {
  String? access;

  Data({
    this.access,
  });

  Data copyWith({
    String? access,
  }) {
    return Data(
      access: access ?? this.access,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'access': access,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      access: map['access'] != null ? map['access'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Data.fromJson(String source) =>
      Data.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Data(access: $access)';

  @override
  bool operator ==(covariant Data other) {
    if (identical(this, other)) return true;

    return other.access == access;
  }

  @override
  int get hashCode => access.hashCode;
}
