class PhonePeInit {
  String message;
  PhonePeData data;

  PhonePeInit({required this.message, required this.data});

  PhonePeInit.fromJson(Map<String, dynamic> json)
      : message = json['message'] ?? '',
        data = PhonePeData.fromJson(json['data'] ?? {});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['message'] = message;
    data['data'] = this.data.toJson();
    return data;
  }
}

class PhonePeData {
  bool success;
  PhonePeDetails details;

  PhonePeData({required this.success, required this.details});

  PhonePeData.fromJson(Map<String, dynamic> json)
      : success = json['success'] ?? false,
        details = PhonePeDetails.fromJson(json['data'] ?? {});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['data'] = details.toJson();
    return data;
  }
}

class PhonePeDetails {
  String code;
  String message;
  PhonePeTransactionData transactionData;

  PhonePeDetails({
    required this.code,
    required this.message,
    required this.transactionData,
  });

  PhonePeDetails.fromJson(Map<String, dynamic> json)
      : code = json['code'] ?? '',
        message = json['message'] ?? '',
        transactionData = PhonePeTransactionData.fromJson(json['data'] ?? {});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['code'] = code;
    data['message'] = message;
    data['data'] = transactionData.toJson();
    return data;
  }
}

class PhonePeTransactionData {
  String merchantId;
  String merchantTransactionId;
  InstrumentResponse instrumentResponse;

  PhonePeTransactionData({
    required this.merchantId,
    required this.merchantTransactionId,
    required this.instrumentResponse,
  });

  PhonePeTransactionData.fromJson(Map<String, dynamic> json)
      : merchantId = json['merchantId'] ?? '',
        merchantTransactionId = json['merchantTransactionId'] ?? '',
        instrumentResponse =
            InstrumentResponse.fromJson(json['instrumentResponse'] ?? {});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['merchantId'] = merchantId;
    data['merchantTransactionId'] = merchantTransactionId;
    data['instrumentResponse'] = instrumentResponse.toJson();
    return data;
  }
}

class InstrumentResponse {
  String type;
  RedirectInfo redirectInfo;

  InstrumentResponse({
    required this.type,
    required this.redirectInfo,
  });

  InstrumentResponse.fromJson(Map<String, dynamic> json)
      : type = json['type'] ?? '',
        redirectInfo = RedirectInfo.fromJson(json['redirectInfo'] ?? {});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['type'] = type;
    data['redirectInfo'] = redirectInfo.toJson();
    return data;
  }
}

class RedirectInfo {
  String url;
  String method;

  RedirectInfo({
    required this.url,
    required this.method,
  });

  RedirectInfo.fromJson(Map<String, dynamic> json)
      : url = json['url'] ?? '',
        method = json['method'] ?? '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['url'] = url;
    data['method'] = method;
    return data;
  }
}
