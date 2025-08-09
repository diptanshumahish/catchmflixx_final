class PhonePePaymentSubscription {
  final bool success;
  final String code;
  final String message;
  final PaymentData transactionData;

  PhonePePaymentSubscription({
    required this.success,
    required this.code,
    required this.message,
    required this.transactionData,
  });

  factory PhonePePaymentSubscription.fromJson(Map<String, dynamic> json) {
    final innerData = json['data'] ?? {};
    return PhonePePaymentSubscription(
      success: innerData['success'] ?? false,
      code: innerData['code'] ?? '',
      message: innerData['message'] ?? '',
      transactionData: PaymentData.fromJson(innerData['data'] ?? {}),
    );
  }
}

class PaymentData {
  final String merchantId;
  final String merchantTransactionId;
  final InstrumentResponse instrumentResponse;

  PaymentData({
    required this.merchantId,
    required this.merchantTransactionId,
    required this.instrumentResponse,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      merchantId: json['merchantId'] ?? '',
      merchantTransactionId: json['merchantTransactionId'] ?? '',
      instrumentResponse: InstrumentResponse.fromJson(
        json['instrumentResponse'] ?? {},
      ),
    );
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
}
