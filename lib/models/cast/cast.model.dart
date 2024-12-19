class CastResponse {
  bool? success;
  List<Data>? data;

  CastResponse({this.success, this.data});

  CastResponse.fromJson(Map<String, dynamic> json) {
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
  Actor? actor;
  String? movieRole;
  String? content;

  Data({this.id, this.actor, this.movieRole, this.content});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    actor = json['actor'] != null ? Actor.fromJson(json['actor']) : null;
    movieRole = json['movie_role'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (actor != null) {
      data['actor'] = actor!.toJson();
    }
    data['movie_role'] = movieRole;
    data['content'] = content;
    return data;
  }
}

class Actor {
  int? id;
  String? name;
  String? image;

  Actor({this.id, this.name, this.image});

  Actor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}
