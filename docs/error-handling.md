## Error Handling & Crash Reporting

Docs: [Home](README.md) • [Architecture](architecture.md) • [Setup](setup.md) • [Routing](routing.md) • [State](state-management.md) • [API](api.md) • [Models](models.md) • [UI](ui.md) • [Localization](localization.md) • [Error Handling](error-handling.md) • [Player](player.md) • [Payments](payments.md) • [Navigation](navigation.md)

### Error Boundary
- `widgets/common/error_boundary.dart` provides a widget-level boundary that catches build-time errors and shows a fallback UI with retry.
- Wraps the entire app in `CatchMFlixxApp`.

### Global Error Handler
- `utils/error/global_error_handler.dart`
  - `GlobalErrorHandler.handleError(error, stackTrace)` logs and sends to Crashlytics
- Crashlytics wired in `AppInitializationService._setupErrorReporting()`

### Result Wrapper
- `utils/error/result.dart` provides a typed `Result<T>` to represent success/failure.

### Networking Errors
- `NetworkManager` and `WebNetworkManager` map Dio exceptions into user-friendly toasts, and parse server messages via `MessageModel`.

See also: [API Layer](api.md).
