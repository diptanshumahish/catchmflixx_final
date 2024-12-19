class WatchProgress {
  bool? success;
  Data? data;

  WatchProgress({this.success, this.data});

  WatchProgress.fromJson(Map<String, dynamic> json) {
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
  String? message;
  VidAd? vidAd;

  Data({this.message, this.vidAd});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    vidAd = json['vid_ad'] != null ? VidAd.fromJson(json['vid_ad']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (vidAd != null) {
      data['vid_ad'] = vidAd!.toJson();
    }
    return data;
  }
}

class VidAd {
  String? uuid;
  String? title;
  String? advertisement;
  String? vodc;
  bool? skippable;

  VidAd({this.uuid, this.title, this.advertisement, this.vodc, this.skippable});

  VidAd.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    title = json['title'];
    advertisement = json['advertisement'];
    vodc = json['vodc'];
    skippable = json['skippable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['title'] = title;
    data['advertisement'] = advertisement;
    data['vodc'] = vodc;
    data['skippable'] = skippable;
    return data;
  }
}
