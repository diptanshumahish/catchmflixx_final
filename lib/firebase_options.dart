// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAStI8xSssftpdy33mq2QesN0OG82WUpQo',
    appId: '1:1005279405528:web:b42ff6336333f90063fead',
    messagingSenderId: '1005279405528',
    projectId: 'cf-notif-72f77',
    authDomain: 'cf-notif-72f77.firebaseapp.com',
    storageBucket: 'cf-notif-72f77.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDMZqMrKamFPrSKi-5o7mjZfYnFwnM8kUk',
    appId: '1:1005279405528:android:1ada329046380a2e63fead',
    messagingSenderId: '1005279405528',
    projectId: 'cf-notif-72f77',
    storageBucket: 'cf-notif-72f77.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDhUo4YLj40O9i871fmWkHcrqx7aqqEe4g',
    appId: '1:1005279405528:ios:b6c944b8affc2f8163fead',
    messagingSenderId: '1005279405528',
    projectId: 'cf-notif-72f77',
    storageBucket: 'cf-notif-72f77.appspot.com',
    iosBundleId: 'com.diptanshumahish.catchmflixxapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDhUo4YLj40O9i871fmWkHcrqx7aqqEe4g',
    appId: '1:1005279405528:ios:b6c944b8affc2f8163fead',
    messagingSenderId: '1005279405528',
    projectId: 'cf-notif-72f77',
    storageBucket: 'cf-notif-72f77.appspot.com',
    iosBundleId: 'com.diptanshumahish.catchmflixxapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAStI8xSssftpdy33mq2QesN0OG82WUpQo',
    appId: '1:1005279405528:web:3bb21ac6fd3e618063fead',
    messagingSenderId: '1005279405528',
    projectId: 'cf-notif-72f77',
    authDomain: 'cf-notif-72f77.firebaseapp.com',
    storageBucket: 'cf-notif-72f77.appspot.com',
  );

}