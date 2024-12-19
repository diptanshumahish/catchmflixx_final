import 'dart:convert';
import 'package:flutter/foundation.dart';

//? For the state management uses, what user is about

class UserDetails {
  bool? success;
  Data? data;

  UserDetails(
    this.success,
    this.data,
  );

  UserDetails copyWith({
    bool? success,
    Data? data,
  }) {
    return UserDetails(
      success ?? this.success,
      data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'data': data?.toMap(),
    };
  }

  factory UserDetails.fromMap(Map<String, dynamic> map) {
    return UserDetails(
      map['success'] != null ? map['success'] as bool : null,
      map['data'] != null
          ? Data.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDetails.fromJson(String source) =>
      UserDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserDetails(success: $success, data: $data)';

  @override
  bool operator ==(covariant UserDetails other) {
    if (identical(this, other)) return true;

    return other.success == success && other.data == data;
  }

  @override
  int get hashCode => success.hashCode ^ data.hashCode;
}

class Data {
  String? uid;
  String? name;
  String? phone_number;
  String? email;
  String? city;
  String? pincode;
  bool? email_is_verified;
  List<Profiles>? profiles;
  UserSub? user_sub;

  Data(
    this.uid,
    this.name,
    this.phone_number,
    this.email,
    this.city,
    this.pincode,
    this.email_is_verified,
    this.profiles,
    this.user_sub,
  );

  Data copyWith({
    String? uid,
    String? name,
    String? phone_number,
    String? email,
    String? city,
    String? pincode,
    bool? email_is_verified,
    List<Profiles>? profiles,
    UserSub? user_sub,
  }) {
    return Data(
      uid ?? this.uid,
      name ?? this.name,
      phone_number ?? this.phone_number,
      email ?? this.email,
      city ?? this.city,
      pincode ?? this.pincode,
      email_is_verified ?? this.email_is_verified,
      profiles ?? this.profiles,
      user_sub ?? this.user_sub,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'phone_number': phone_number,
      'email': email,
      'city': city,
      'pincode': pincode,
      'email_is_verified': email_is_verified,
      'profiles': profiles!.map((x) => x.toMap()).toList(),
      'user_sub': user_sub?.toMap(),
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      map['uid'] != null ? map['uid'] as String : null,
      map['name'] != null ? map['name'] as String : null,
      map['phone_number'] != null ? map['phone_number'] as String : null,
      map['email'] != null ? map['email'] as String : null,
      map['city'] != null ? map['city'] as String : null,
      map['pincode'] != null ? map['pincode'] as String : null,
      map['email_is_verified'] != null
          ? map['email_is_verified'] as bool
          : null,
      map['profiles'] != null
          ? List<Profiles>.from(
              (map['profiles'] as List<dynamic>).map<Profiles?>(
                (x) => Profiles.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      map['user_sub'] != null
          ? UserSub.fromMap(map['user_sub'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Data.fromJson(String source) =>
      Data.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Data(uid: $uid, name: $name, phone_number: $phone_number, email: $email, city: $city, pincode: $pincode, email_is_verified: $email_is_verified, profiles: $profiles, user_sub: $user_sub)';
  }

  @override
  bool operator ==(covariant Data other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.phone_number == phone_number &&
        other.email == email &&
        other.city == city &&
        other.pincode == pincode &&
        other.email_is_verified == email_is_verified &&
        listEquals(other.profiles, profiles) &&
        other.user_sub == user_sub;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        phone_number.hashCode ^
        email.hashCode ^
        city.hashCode ^
        pincode.hashCode ^
        email_is_verified.hashCode ^
        profiles.hashCode ^
        user_sub.hashCode;
  }
}

class Profiles {
  String? name;
  String? avatar;
  String? profile_type;

  Profiles({
    this.name,
    this.avatar,
    this.profile_type,
  });

  Profiles copyWith({
    String? name,
    String? avatar,
    String? profile_type,
  }) {
    return Profiles(
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      profile_type: profile_type ?? this.profile_type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'avatar': avatar,
      'profile_type': profile_type,
    };
  }

  factory Profiles.fromMap(Map<String, dynamic> map) {
    return Profiles(
      name: map['name'] != null ? map['name'] as String : null,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
      profile_type:
          map['profile_type'] != null ? map['profile_type'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Profiles.fromJson(String source) =>
      Profiles.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Profiles(name: $name, avatar: $avatar, profile_type: $profile_type)';

  @override
  bool operator ==(covariant Profiles other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.avatar == avatar &&
        other.profile_type == profile_type;
  }

  @override
  int get hashCode => name.hashCode ^ avatar.hashCode ^ profile_type.hashCode;
}

class UserSub {
  Plan? plan;

  UserSub({
    this.plan,
  });

  UserSub copyWith({
    Plan? plan,
  }) {
    return UserSub(
      plan: plan ?? this.plan,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'plan': plan?.toMap(),
    };
  }

  factory UserSub.fromMap(Map<String, dynamic> map) {
    return UserSub(
      plan: map['plan'] != null
          ? Plan.fromMap(map['plan'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserSub.fromJson(String source) =>
      UserSub.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserSub(plan: $plan)';

  @override
  bool operator ==(covariant UserSub other) {
    if (identical(this, other)) return true;

    return other.plan == plan;
  }

  @override
  int get hashCode => plan.hashCode;
}

class Plan {
  String? name;
  int? max_profiles;

  Plan({
    this.name,
    this.max_profiles,
  });

  Plan copyWith({
    String? name,
    int? max_profiles,
  }) {
    return Plan(
      name: name ?? this.name,
      max_profiles: max_profiles ?? this.max_profiles,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'max_profiles': max_profiles,
    };
  }

  factory Plan.fromMap(Map<String, dynamic> map) {
    return Plan(
      name: map['name'] != null ? map['name'] as String : null,
      max_profiles:
          map['max_profiles'] != null ? map['max_profiles'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Plan.fromJson(String source) =>
      Plan.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Plan(name: $name, max_profiles: $max_profiles)';

  @override
  bool operator ==(covariant Plan other) {
    if (identical(this, other)) return true;

    return other.name == name && other.max_profiles == max_profiles;
  }

  @override
  int get hashCode => name.hashCode ^ max_profiles.hashCode;
}
