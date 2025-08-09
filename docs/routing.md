## Routing (go_router)

Docs: [Home](README.md) • [Architecture](architecture.md) • [Setup](setup.md) • [Routing](routing.md) • [State](state-management.md) • [API](api.md) • [Models](models.md) • [UI](ui.md) • [Localization](localization.md) • [Error Handling](error-handling.md) • [Player](player.md) • [Payments](payments.md) • [Navigation](navigation.md)

Entry: `lib/utils/go_router/go.dart`

### Initial Location
- `/` → `SplashScreen`

### Routes
- `/payment-make` → `BaseMain`
- `/web-view` (extra: `String url`) → `WebPage`
- `/error` → `ErrorScreen`
- `/en/payment-success` → `PaymentSuccessScreen`
- `/forgot-password` → `ForgotPasswordScreen`
- Root shell: `/` → `BaseMain` with nested:
  - `/en/watch/watch-now/movie?id=:id` → `MovieScreen`
  - `/en/watch/watch-now/series?id=:id` → `SeriesScreen`
- `/en/sign-in-app/success?accessToken=:aId&idToken=:token` → `RedirectScreen`
- `/splash` → `SplashScreen`
- `/base` → `BaseMain`
- `/max-login` (extra: `MaxLimit`) → `MaxLogin`
- `/movie/:uuid` → `MovieScreen`
- `/series/:uuid` → `SeriesScreen`
- `/user/history` → `HistoryListWidget`
- `/user/watch-list` → `MyToWatchList`
- `/check-login` → `CheckLoggedIn`
- `/onboard/:key` → `OnboardScreen`
- `/user/profile-management` → `ProfileManagement`
- `/languages` → `LanguageScreen`
- `/player` (extra: `PlayerScreen`) → `SecureScreenWrapper(PlayerScreen(...))`
- `/user/profile/edit` (extra: `EditProfile`) → `EditProfile`
- `/verify/email` (extra: `VerifyEmail`) → `VerifyEmail`
- `/user/profile-selection` (extra: `ProfilesList`) → `ProfilesSelection`
- `/version` → `VersionScreen`
- `/plans` → `AllPlansScreen`
- `/custom-modal` (extra: `CustomModal`) → `CustomModal`
- `/movie-rent` (extra: `RentingScreen`) → `RentingScreen`
- `/episode-rent` (extra: `EpisodeRentingScreen`) → `EpisodeRentingScreen`
- `/season-renting` (extra: `{ act, title, img, id, seasonNumber }`) → `SeasonRentingScreen`
- `/settings` → `SettingsScreen`

See also: [Navigation Helpers](navigation.md).
