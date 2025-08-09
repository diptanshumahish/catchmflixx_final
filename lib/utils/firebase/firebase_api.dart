import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handler(RemoteMessage message) async {
  return;
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(handler);
  }
}
