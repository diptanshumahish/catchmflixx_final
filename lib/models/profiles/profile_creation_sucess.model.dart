class ProfileCreationResponse {
  String? uuid;
  String? hash;
  String? name;
  String? profileType;
  String? avatar;
  int? avatarId;
  bool? isProtected;

  ProfileCreationResponse(
      {this.uuid,
      this.hash,
      this.name,
      this.profileType,
      this.avatar,
      this.avatarId,
      this.isProtected});

  ProfileCreationResponse.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    hash = json['hash'];
    name = json['name'];
    profileType = json['profile_type'];
    avatar = json['avatar'];
    avatarId = json['avatar_id'];
    isProtected = json['is_protected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['hash'] = hash;
    data['name'] = name;
    data['profile_type'] = profileType;
    data['avatar'] = avatar;
    data['avatar_id'] = avatarId;
    data['is_protected'] = isProtected;
    return data;
  }
}
