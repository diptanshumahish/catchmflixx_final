## Architecture

Docs: [Home](README.md) • [Architecture](architecture.md) • [Setup](setup.md) • [Routing](routing.md) • [State](state-management.md) • [API](api.md) • [Models](models.md) • [UI](ui.md) • [Localization](localization.md) • [Error Handling](error-handling.md) • [Player](player.md) • [Payments](payments.md) • [Navigation](navigation.md)

### Runtime Flow
1. `main.dart`
   - Calls `AppInitializationService.initializeApp()`
   - Runs the app with a `ProviderScope` and `CatchMFlixxApp`
2. `CatchMFlixxApp`
   - Wraps the app with `ErrorBoundary`
   - Reads current language from `languageProvider`
   - Delegates to `AppConfig.buildApp()` (Material on Android, Cupertino on iOS)
3. `AppConfig`
   - Configures router (`go_router`), theme, and localization delegates
4. Router config: see [Routing](routing.md)
5. Screens/widgets
   - Composed UI using custom typography, responsive utilities, and feature widgets

### Layers
- Presentation: `screens/`, `widgets/`, `theme/`, `constants/`, `utils/responsive`
- State: `state/` (Riverpod `StateNotifier`/providers) – see [State Management](state-management.md)
- Domain/Models: `models/` – see [Models](models.md)
- Data/API: `api/` (Dio networking, payments, content, auth) – see [API Layer](api.md)
- Platform/Infra: `utils/app`, `utils/firebase`, `utils/navigation`, `utils/error`, `utils/deviceinfo`

### Key Components
- Initialization: `AppInitializationService`
- Router: `GoRouter appRoute`
- Theming: `CatchMFLixxTheme` (Material) and `CatchMFLixxThemeIOS` (Cupertino)
- Typography: `AppText` and `AppTypography` unify text styling – see [UI](ui.md)
- State: providers in `state/provider.dart`
- Networking: `NetworkManager` and `WebNetworkManager`

### Data Flow
UI → Providers → API Managers → Models → Providers update → UI watches

### Error Strategy
- Widget-level: `widgets/common/error_boundary.dart` – see [Error Handling](error-handling.md)
- Global: `GlobalErrorHandler` + Crashlytics bindings in initialization

### Responsive Design
- `ResponsiveUtils` and `ResponsiveTheme` – see [UI](ui.md)
