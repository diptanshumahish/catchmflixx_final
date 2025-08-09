## CatchMFlixx Documentation

Docs: [Home](README.md) • [Architecture](architecture.md) • [Setup](setup.md) • [Routing](routing.md) • [State](state-management.md) • [API](api.md) • [Models](models.md) • [UI](ui.md) • [Localization](localization.md) • [Error Handling](error-handling.md) • [Player](player.md) • [Payments](payments.md) • [Navigation](navigation.md)

Welcome to the CatchMFlixx codebase documentation. This folder provides a comprehensive overview of the app's architecture, modules, workflows, and how to extend or maintain the project.

### Quick Links
- [Architecture](architecture.md)
- [Project Setup](setup.md)
- [Routing](routing.md)
- [State Management](state-management.md)
- [API Layer](api.md)
- [Models](models.md)
- [UI, Theme, Typography, Responsive](ui.md)
- [Localization (i18n)](localization.md)
- [Error Handling & Crash Reporting](error-handling.md)
- [Player](player.md)
- [Payments](payments.md)
- [Navigation Helpers](navigation.md)

### High-level Summary
- Flutter app using Material/Cupertino with Riverpod for state management and `go_router` for navigation.
- App initialization sets orientation, display mode, Firebase, error reporting, and networking.
- Robust network layer built on Dio with cookie persistence, token refresh, and dual base URLs.
- Strong modular separation: `api/`, `models/`, `screens/`, `widgets/`, `state/`, `utils/`, `theme/`.
- Theming unified by custom typography and an `AppText` wrapper to keep text consistent.

For details, open the individual docs linked above.
