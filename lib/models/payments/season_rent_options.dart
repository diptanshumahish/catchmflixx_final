class SeasonRentModel {
  bool? success;
  List<Data>? data;

  SeasonRentModel({this.success, this.data});

  SeasonRentModel.fromJson(Map<String, dynamic> json) {
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
  int? days;
  num? price;
  String? createdOn;
  String? season;

  Data({this.id, this.days, this.price, this.createdOn, this.season});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    days = json['days'];
    price = json['price'];
    createdOn = json['created_on'];
    season = json['season'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['days'] = days;
    data['price'] = price;
    data['created_on'] = createdOn;
    data['season'] = season;
    return data;
  }
}
