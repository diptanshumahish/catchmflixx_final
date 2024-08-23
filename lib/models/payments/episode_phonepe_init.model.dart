class EpisodePhonePeInit {
  final bool success;
  final EpisodeData data;

  EpisodePhonePeInit({required this.success, required this.data});

  factory EpisodePhonePeInit.fromJson(Map<String, dynamic> json) {
    return EpisodePhonePeInit(
      success: json['success'] ?? false,
      data: EpisodeData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.toJson(),
    };
  }
}

class EpisodeData {
  final bool success;
  final String code;
  final String message;
  final TransactionData data;

  EpisodeData({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory EpisodeData.fromJson(Map<String, dynamic> json) {
    return EpisodeData(
      success: json['success'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      data: TransactionData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'code': code,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class TransactionData {
  final String merchantId;
  final String merchantTransactionId;
  final InstrumentResponse instrumentResponse;

  TransactionData({
    required this.merchantId,
    required this.merchantTransactionId,
    required this.instrumentResponse,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      merchantId: json['merchantId'] ?? '',
      merchantTransactionId: json['merchantTransactionId'] ?? '',
      instrumentResponse:
          InstrumentResponse.fromJson(json['instrumentResponse'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'merchantId': merchantId,
      'merchantTransactionId': merchantTransactionId,
      'instrumentResponse': instrumentResponse.toJson(),
    };
  }
}

class InstrumentResponse {
  final String type;
  final RedirectInfo redirectInfo;

  InstrumentResponse({
    required this.type,
    required this.redirectInfo,
  });

  factory InstrumentResponse.fromJson(Map<String, dynamic> json) {
    return InstrumentResponse(
      type: json['type'] ?? '',
      redirectInfo: RedirectInfo.fromJson(json['redirectInfo'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'redirectInfo': redirectInfo.toJson(),
    };
  }
}

class RedirectInfo {
  final String url;
  final String method;

  RedirectInfo({
    required this.url,
    required this.method,
  });

  factory RedirectInfo.fromJson(Map<String, dynamic> json) {
    return RedirectInfo(
      url: json['url'] ?? '',
      method: json['method'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'method': method,
    };
  }
}
