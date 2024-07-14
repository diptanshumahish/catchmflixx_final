//? this model is for getting the available languages
class LanguageModel {
  bool success;
  Map<String, String> data;

  LanguageModel({required this.success, required this.data});

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      success: json['success'],
      data: Map<String, String>.from(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data,
    };
  }
}
