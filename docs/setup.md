## Project Setup

Docs: [Home](README.md) • [Architecture](architecture.md) • [Setup](setup.md) • [Routing](routing.md) • [State](state-management.md) • [API](api.md) • [Models](models.md) • [UI](ui.md) • [Localization](localization.md) • [Error Handling](error-handling.md) • [Player](player.md) • [Payments](payments.md) • [Navigation](navigation.md)

### Prerequisites
- Flutter SDK (Dart >= 3.4.3)
- Xcode (iOS), Android Studio (Android)
- Firebase project configured (keys are in `lib/firebase_options.dart`)

### Dependencies
See `pubspec.yaml` for the full list. Core packages:
- `flutter_riverpod`, `riverpod_annotation`, `custom_lint`, `riverpod_generator`
- `go_router`
- `dio`, `cookie_jar`, `dio_cookie_manager`, `path_provider`
- `firebase_core`, `firebase_messaging`, `firebase_crashlytics`, `firebase_analytics`, `firebase_auth`
- `google_sign_in`, `sign_in_with_apple`
- `video_player`, `wakelock_plus`
- `cached_network_image`, `flutter_svg`, `flutter_animate`, `shimmer`
- `intl`, `share_plus`, `upgrader`

### Run
- iOS: `flutter run -d ios`
- Android: `flutter run -d android`

### Build
- iOS: `flutter build ios` (configure signing in Xcode)
- Android: `flutter build apk` or `flutter build appbundle`

### Firebase
Initialization occurs in `AppInitializationService._initializeFirebase()`.
- Ensure platform configs are added.
- Background messaging handler is registered in [`lib/utils/firebase/firebase_api.dart`](../lib/utils/firebase/firebase_api.dart).

### Environment
- App orientation is portrait by default.
- High refresh rate enabled on Android via `flutter_displaymode`.

### L10n
- Supported locales: en, hi, kn, ml, te, ta.
- ARB sources under `lib/l10n`. See [Localization](localization.md).
