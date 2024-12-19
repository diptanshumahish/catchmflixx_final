import 'dart:convert';

// ? Will be the object type when registration is being done.

class RegisterResponse {
  bool? success;
  Data? data;
  RegisterResponse({
    this.success,
    this.data,
  });

  RegisterResponse copyWith({
    bool? success,
    Data? data,
  }) {
    return RegisterResponse(
      success: success ?? this.success,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'data': data?.toMap(),
    };
  }

  factory RegisterResponse.fromMap(Map<String, dynamic> map) {
    return RegisterResponse(
      success: map['success'] != null ? map['success'] as bool : null,
      data: map['data'] != null
          ? Data.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisterResponse.fromJson(String source) =>
      RegisterResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'RegisterResponse(success: $success, data: $data)';

  @override
  bool operator ==(covariant RegisterResponse other) {
    if (identical(this, other)) return true;

    return other.success == success && other.data == data;
  }

  @override
  int get hashCode => success.hashCode ^ data.hashCode;
}

class Data {
  String? message;

  Data({
    this.message,
  });

  Data copyWith({
    String? message,
  }) {
    return Data(
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      message: map['message'] != null ? map['message'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Data.fromJson(String source) =>
      Data.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Data(message: $message)';

  @override
  bool operator ==(covariant Data other) {
    if (identical(this, other)) return true;

    return other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
