class UserActivityHistory {
  bool? success;
  List<Data>? data;

  UserActivityHistory({this.success, this.data});

  UserActivityHistory.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? profile;
  Video? video;
  String? contentName;
  String? contentType;
  String? contentUuid;
  int? progressSeconds;
  int? durationMinutes;
  String? lastWatchedTime;

  Data(
      {this.profile,
      this.video,
      this.contentName,
      this.contentType,
      this.contentUuid,
      this.progressSeconds,
      this.durationMinutes,
      this.lastWatchedTime});

  Data.fromJson(Map<String, dynamic> json) {
    profile = json['profile'];
    video = json['video'] != null ? Video.fromJson(json['video']) : null;
    contentName = json['content_name'];
    contentType = json['content_type'];
    contentUuid = json['content_uuid'];
    progressSeconds = json['progress_seconds'];
    durationMinutes = json['duration_minutes'];
    lastWatchedTime = json['last_watched_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profile'] = profile;
    if (video != null) {
      data['video'] = video!.toJson();
    }
    data['content_name'] = contentName;
    data['content_type'] = contentType;
    data['content_uuid'] = contentUuid;
    data['progress_seconds'] = progressSeconds;
    data['duration_minutes'] = durationMinutes;
    data['last_watched_time'] = lastWatchedTime;
    return data;
  }
}

class Video {
  String? url;
  String? thumbnail;
  String? trailer;

  Video({this.url, this.thumbnail, this.trailer});

  Video.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    thumbnail = json['thumbnail'];
    trailer = json['trailer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['thumbnail'] = thumbnail;
    data['trailer'] = trailer;
    return data;
  }
}
