import 'dart:convert';

import 'package:flutter/foundation.dart';

class ProfilesList {
  bool? success;
  List<Data>? data;

  ProfilesList({
    this.success,
    this.data,
  });

  ProfilesList copyWith({
    bool? success,
    List<Data>? data,
  }) {
    return ProfilesList(
      success: success ?? this.success,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'data': data!.map((x) => x.toMap()).toList(),
    };
  }

  factory ProfilesList.fromMap(Map<String, dynamic> map) {
    return ProfilesList(
      success: map['success'] != null ? map['success'] as bool : null,
      data: map['data'] != null
          ? List<Data>.from(
              (map['data'] as List<dynamic>).map<Data?>(
                (x) => Data.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfilesList.fromJson(String source) =>
      ProfilesList.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ProfilesList(success: $success, data: $data)';

  @override
  bool operator ==(covariant ProfilesList other) {
    if (identical(this, other)) return true;

    return other.success == success && listEquals(other.data, data);
  }

  @override
  int get hashCode => success.hashCode ^ data.hashCode;
}

class Data {
  String? uuid;
  String? hash;
  String? name;
  String? profile_type;
  String? avatar;
  int? avatar_id;
  bool? is_protected;

  Data(this.uuid, this.hash, this.name, this.profile_type, this.avatar,
      this.avatar_id, this.is_protected);

  Data copyWith({
    String? uuid,
    String? hash,
    String? name,
    String? profile_type,
    String? avatar,
    int? avatar_id,
    bool? is_protected,
  }) {
    return Data(
      uuid ?? this.uuid,
      hash ?? this.hash,
      name ?? this.name,
      profile_type ?? this.profile_type,
      avatar ?? this.avatar,
      avatar_id ?? this.avatar_id,
      is_protected ?? this.is_protected,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'hash': hash,
      'name': name,
      'profile_type': profile_type,
      'avatar': avatar,
      'avatar_id': avatar_id,
      'is_protected': is_protected,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      map['uuid'] != null ? map['uuid'] as String : null,
      map['hash'] != null ? map['hash'] as String : null,
      map['name'] != null ? map['name'] as String : null,
      map['profile_type'] != null ? map['profile_type'] as String : null,
      map['avatar'] != null ? map['avatar'] as String : null,
      map['avatar_id'] != null ? map['avatar_id'] as int : null,
      map['is_protected'] != null ? map['is_protected'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Data.fromJson(String source) =>
      Data.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Data(uuid: $uuid, hash: $hash, name: $name, profile_type: $profile_type, avatar: $avatar, avatar_id: $avatar_id, is_protected: $is_protected)';
  }

  @override
  bool operator ==(covariant Data other) {
    if (identical(this, other)) return true;

    return other.uuid == uuid &&
        other.hash == hash &&
        other.name == name &&
        other.profile_type == profile_type &&
        other.avatar == avatar &&
        other.avatar_id == avatar_id &&
        other.is_protected == is_protected;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        hash.hashCode ^
        name.hashCode ^
        profile_type.hashCode ^
        avatar.hashCode ^
        avatar_id.hashCode ^
        is_protected.hashCode;
  }
}
