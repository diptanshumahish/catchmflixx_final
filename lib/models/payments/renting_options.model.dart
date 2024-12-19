class RentingOptions {
  bool? success;
  List<Data>? data;

  RentingOptions({this.success, this.data});

  RentingOptions.fromJson(Map<String, dynamic> json) {
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
  String? movie;
  int? days;
  dynamic price;

  Data({this.id, this.movie, this.days, this.price});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    movie = json['movie'];
    days = json['days'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['movie'] = movie;
    data['days'] = days;
    data['price'] = price;
    return data;
  }
}
