class LoggedInCurrentProfile {
  String? name;
  String? profileType;
  String? avatar;
  bool? isProtected;

  LoggedInCurrentProfile(
      {this.name, this.profileType, this.avatar, this.isProtected});

  LoggedInCurrentProfile.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profileType = json['profile_type'];
    avatar = json['avatar'];
    isProtected = json['is_protected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['profile_type'] = profileType;
    data['avatar'] = avatar;
    data['is_protected'] = isProtected;
    return data;
  }
}
