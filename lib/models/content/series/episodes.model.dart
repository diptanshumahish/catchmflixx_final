class EpisodesModel {
  bool? success;
  Data? data;

  EpisodesModel({this.success, this.data});

  EpisodesModel.fromJson(Map<String, dynamic> json) {
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
  int? number;
  String? suuid;
  String? content;
  Seasonmeta? seasonmeta;
  List<Episodes>? episodes;

  Data({this.number, this.suuid, this.content, this.seasonmeta, this.episodes});

  Data.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    suuid = json['suuid'];
    content = json['content'];
    seasonmeta = json['seasonmeta'] != null
        ? Seasonmeta.fromJson(json['seasonmeta'])
        : null;
    if (json['episodes'] != null) {
      episodes = <Episodes>[];
      json['episodes'].forEach((v) {
        episodes!.add(Episodes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number'] = number;
    data['suuid'] = suuid;
    data['content'] = content;
    if (seasonmeta != null) {
      data['seasonmeta'] = seasonmeta!.toJson();
    }
    if (episodes != null) {
      data['episodes'] = episodes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Seasonmeta {
  Language? language;
  String? title;
  String? description;

  Seasonmeta({this.language, this.title, this.description});

  Seasonmeta.fromJson(Map<String, dynamic> json) {
    language =
        json['language'] != null ? Language.fromJson(json['language']) : null;
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (language != null) {
      data['language'] = language!.toJson();
    }
    data['title'] = title;
    data['description'] = description;
    return data;
  }
}

class Language {
  int? id;
  String? language;
  String? code;

  Language({this.id, this.language, this.code});

  Language.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    language = json['language'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['language'] = language;
    data['code'] = code;
    return data;
  }
}

class Episodes {
  String? videoUuid;
  int? epNumber;
  String? thumbnail;
  String? subTitle;
  String? subDescription;
  String? url;
  String? trailer;
  int? durationMinutes;
  int? progress;

  Episodes(
      {this.videoUuid,
      this.epNumber,
      this.thumbnail,
      this.subTitle,
      this.subDescription,
      this.url,
      this.trailer,
      this.progress,
      this.durationMinutes});

  Episodes.fromJson(Map<String, dynamic> json) {
    videoUuid = json['video_uuid'];
    epNumber = json['ep_number'];
    thumbnail = json['thumbnail'];
    subTitle = json['sub_title'];
    subDescription = json['sub_description'];
    url = json['url'];
    trailer = json['trailer'];
    progress = json['progress'];
    durationMinutes = json['duration_minutes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['video_uuid'] = videoUuid;
    data['ep_number'] = epNumber;
    data['thumbnail'] = thumbnail;
    data['sub_title'] = subTitle;
    data['sub_description'] = subDescription;
    data['url'] = url;
    data['trailer'] = trailer;
    data['progress'] = progress;
    data['duration_minutes'] = durationMinutes;
    return data;
  }
}
