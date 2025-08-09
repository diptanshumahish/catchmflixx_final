class SeriesSeasons {
  bool? success;
  Data? data;

  SeriesSeasons({this.success, this.data});

  SeriesSeasons.fromJson(Map<String, dynamic> json) {
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
  List<Seasons>? seasons;
  String? censor;
  String? releaseDate;
  String? thumbnail;
  String? trailer;

  Data(
      {this.uuid,
      this.type,
      this.genres,
      this.watchlater,
      this.contentmeta,
      this.seasons,
      this.censor,
      this.releaseDate,
      this.thumbnail,
      this.trailer});

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
    if (json['seasons'] != null) {
      seasons = <Seasons>[];
      json['seasons'].forEach((v) {
        seasons!.add(Seasons.fromJson(v));
      });
    }
    censor = json['censor'];
    releaseDate = json['release_date'];
    thumbnail = json['thumbnail'];
    trailer = json['trailer'];
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
    if (seasons != null) {
      data['seasons'] = seasons!.map((v) => v.toJson()).toList();
    }
    data['censor'] = censor;
    data['release_date'] = releaseDate;
    data['thumbnail'] = thumbnail;
    data['trailer'] = trailer;
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

class Seasons {
  String? suuid;
  int? number;
  String? subTitle;
  String? subDescription;
  String? thumbnail;
  String? trailer;
  int? noOfEpisodes;
  bool? free;

  Seasons(
      {this.suuid,
      this.number,
      this.subTitle,
      this.subDescription,
      this.thumbnail,
      this.trailer,
      this.noOfEpisodes,
      this.free});

  Seasons.fromJson(Map<String, dynamic> json) {
    suuid = json['suuid'];
    number = json['number'];
    subTitle = json['sub_title'];
    subDescription = json['sub_description'];
    thumbnail = json['thumbnail'];
    trailer = json['trailer'];
    noOfEpisodes = json['no_of_episodes'];
    free = json['free'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['suuid'] = suuid;
    data['number'] = number;
    data['sub_title'] = subTitle;
    data['sub_description'] = subDescription;
    data['thumbnail'] = thumbnail;
    data['trailer'] = trailer;
    data['no_of_episodes'] = noOfEpisodes;
    data['free'] = free;
    return data;
  }
}
