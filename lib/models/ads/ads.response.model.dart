//? will most probably be the only ads model
class AdsResponse {
  bool? success;
  List<Data>? data;

  AdsResponse({this.success, this.data});

  AdsResponse.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? name;
  String? banner;
  List<String>? zipcode;
  String? title;
  String? link;
  String? callToAction;

  Data(
      {this.id,
      this.name,
      this.banner,
      this.zipcode,
      this.title,
      this.link,
      this.callToAction});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    banner = json['banner'];
    zipcode = json['zipcode'].cast<String>();
    title = json['title'];
    link = json['link'];
    callToAction = json['call_to_action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['banner'] = banner;
    data['zipcode'] = zipcode;
    data['title'] = title;
    data['link'] = link;
    data['call_to_action'] = callToAction;
    return data;
  }
}
