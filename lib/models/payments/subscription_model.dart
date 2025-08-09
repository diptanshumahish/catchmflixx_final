class SubscriptionPlans {
  final bool success;
  final List<Daum> data;

  SubscriptionPlans({
    required this.success,
    required this.data,
  });

  factory SubscriptionPlans.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlans(
      success: json['success'],
      data: List<Daum>.from(json['data'].map((x) => Daum.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((x) => x.toJson()).toList(),
    };
  }
}

class Daum {
  final int id;
  final String name;
  final String price;
  final int maxProfiles;
  final bool current;
  final int validity_days;

  Daum({
    required this.id,
    required this.name,
    required this.price,
    required this.maxProfiles,
    required this.current,
    required this.validity_days,
  });

  factory Daum.fromJson(Map<String, dynamic> json) {
    return Daum(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      maxProfiles: json['max_profiles'],
      current: json['current'],
      validity_days: json['validity_days'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'max_profiles': maxProfiles,
      'current': current,
      'validity_days': validity_days,
    };
  }
}
