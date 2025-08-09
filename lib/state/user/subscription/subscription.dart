import 'package:catchmflixx/api/payments/payments.dart';
import 'package:catchmflixx/models/payments/subscription_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<SubscriptionPlans> getStaticUserSubscriptions() async {
  PaymentsManager pm = PaymentsManager();
  return await pm.getSubscriptions() ??
      SubscriptionPlans(success: false, data: []);
}

class UserSubscriptionNotifier extends StateNotifier<SubscriptionPlans> {
  UserSubscriptionNotifier()
      : super(SubscriptionPlans(success: false, data: [])) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    SubscriptionPlans data = await getStaticUserSubscriptions();
    print(data);
    state = data;
  }

  Future<void> updateState() async {
    SubscriptionPlans data = await getStaticUserSubscriptions();
    state = data;
  }

  Daum? get currentPlan {
    return state.data.firstWhere(
      (plan) => plan.current,
      orElse: () =>
          Daum(id: 0, name: '', price: '', maxProfiles: 0, current: false,
              validity_days: 0),
    );
  }

  bool get isSubscribed => currentPlan?.current == true;
}
