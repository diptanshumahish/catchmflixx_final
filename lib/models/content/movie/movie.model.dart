class MovieFullModel {
  bool? success;
  Data? data;

  MovieFullModel({this.success, this.data});

  MovieFullModel.fromJson(Map<String, dynamic> json) {
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
  String? uuid;
  String? type;
  List<Genres>? genres;
  bool? watchlater;
  Contentmeta? contentmeta;
  String? censor;
  String? releaseDate;
  Videos? videos;
  bool? userRented;
  bool? free;

  Data(
      {this.uuid,
      this.type,
      this.genres,
      this.watchlater,
      this.contentmeta,
      this.censor,
      this.releaseDate,
      this.videos,
      this.userRented,
      this.free});

  Data.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    type = json['type'];
    if (json['genres'] != null) {
      genres = <Genres>[];
      json['genres'].forEach((v) {
        genres!.add(Genres.fromJson(v));
      });
    }
    watchlater = json['watchlater'];
    contentmeta = json['contentmeta'] != null
        ? Contentmeta.fromJson(json['contentmeta'])
        : null;
    censor = json['censor'];
    releaseDate = json['release_date'];
    videos = json['videos'] != null ? Videos.fromJson(json['videos']) : null;
    userRented = json['user_rented'];
    free = json['free'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['type'] = type;
    if (genres != null) {
      data['genres'] = genres!.map((v) => v.toJson()).toList();
    }
    data['watchlater'] = watchlater;
    if (contentmeta != null) {
      data['contentmeta'] = contentmeta!.toJson();
    }
    data['censor'] = censor;
    data['release_date'] = releaseDate;
    if (videos != null) {
      data['videos'] = videos!.toJson();
    }
    data['user_rented'] = userRented;
    data['free'] = free;
    return data;
  }
}

class Genres {
  int? id;
  String? name;

  Genres({this.id, this.name});

  Genres.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Contentmeta {
  Language? language;
  String? title;
  String? description;

  Contentmeta({this.language, this.title, this.description});

  Contentmeta.fromJson(Map<String, dynamic> json) {
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

class Videos {
  String? videoUuid;
  String? url;
  String? thumbnail;
  String? trailer;
  int? progress;
  int? durationMinutes;

  Videos(
      {this.videoUuid,
      this.url,
      this.thumbnail,
      this.trailer,
      this.progress,
      this.durationMinutes});

  Videos.fromJson(Map<String, dynamic> json) {
    videoUuid = json['video_uuid'];
    url = json['url'];
    thumbnail = json['thumbnail'];
    trailer = json['trailer'];
    progress = json['progress'];
    durationMinutes = json['duration_minutes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['video_uuid'] = videoUuid;
    data['url'] = url;
    data['thumbnail'] = thumbnail;
    data['trailer'] = trailer;
    data['progress'] = progress;
    data['duration_minutes'] = durationMinutes;
    return data;
  }
}
