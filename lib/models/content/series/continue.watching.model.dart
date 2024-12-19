class CurrentWatching {
  bool? success;
  Data? data;

  CurrentWatching({this.success, this.data});

  CurrentWatching.fromJson(Map<String, dynamic> json) {
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
  String? videoUuid;
  int? epNumber;
  int? seasonNumber;
  String? thumbnail;
  String? subTitle;
  String? subDescription;
  String? url;
  String? trailer;
  int? durationMinutes;
  int? progress;

  Data(
      {this.videoUuid,
      this.epNumber,
      this.seasonNumber,
      this.thumbnail,
      this.subTitle,
      this.subDescription,
      this.url,
      this.trailer,
      this.durationMinutes,
      this.progress});

  Data.fromJson(Map<String, dynamic> json) {
    videoUuid = json['video_uuid'];
    epNumber = json['ep_number'];
    seasonNumber = json['season_number'];
    thumbnail = json['thumbnail'];
    subTitle = json['sub_title'];
    subDescription = json['sub_description'];
    url = json['url'];
    trailer = json['trailer'];
    durationMinutes = json['duration_minutes'];
    progress = json['progress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['video_uuid'] = videoUuid;
    data['ep_number'] = epNumber;
    data['season_number'] = seasonNumber;
    data['thumbnail'] = thumbnail;
    data['sub_title'] = subTitle;
    data['sub_description'] = subDescription;
    data['url'] = url;
    data['trailer'] = trailer;
    data['duration_minutes'] = durationMinutes;
    data['progress'] = progress;
    return data;
  }
}
