class WatchLaterList {
  bool? success;
  List<Data>? data;

  WatchLaterList({this.success, this.data});

  WatchLaterList.fromJson(Map<String, dynamic> json) {
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
  String? uuid;
  MetaData? metaData;
  String? thumbnail;
  String? type;
  bool? watchlater;
  String? suuid;

  Data(
      {this.uuid,
      this.metaData,
      this.thumbnail,
      this.type,
      this.watchlater,
      this.suuid});

  Data.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    metaData =
        json['meta_data'] != null ? MetaData.fromJson(json['meta_data']) : null;
    thumbnail = json['thumbnail'];
    type = json['type'];
    watchlater = json['watchlater'];
    suuid = json['suuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    if (metaData != null) {
      data['meta_data'] = metaData!.toJson();
    }
    data['thumbnail'] = thumbnail;
    data['type'] = type;
    data['watchlater'] = watchlater;
    data['suuid'] = suuid;
    return data;
  }
}

class MetaData {
  Language? language;
  String? title;
  String? description;

  MetaData({this.language, this.title, this.description});

  MetaData.fromJson(Map<String, dynamic> json) {
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
