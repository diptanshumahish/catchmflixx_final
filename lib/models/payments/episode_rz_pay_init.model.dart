class RzPayInit {
  bool success;
  Data data;

  RzPayInit({required this.success, required this.data});

  RzPayInit.fromJson(Map<String, dynamic> json)
      : success = json['success'] ?? false,
        data = Data.fromJson(json['data'] ?? {});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['data'] = this.data.toJson();
    return data;
  }
}

class Data {
  String id;
  String referenceId;
  String shortUrl;

  Data({required this.id, required this.referenceId, required this.shortUrl});

  Data.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        referenceId = json['reference_id'] ?? '',
        shortUrl = json['short_url'] ?? '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reference_id'] = referenceId;
    data['short_url'] = shortUrl;
    return data;
  }
}
