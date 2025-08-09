## Navigation Helpers

Docs: [Home](README.md) • [Architecture](architecture.md) • [Setup](setup.md) • [Routing](routing.md) • [State](state-management.md) • [API](api.md) • [Models](models.md) • [UI](ui.md) • [Localization](localization.md) • [Error Handling](error-handling.md) • [Player](player.md) • [Payments](payments.md) • [Navigation](navigation.md)

### Helper
- `utils/navigation/navigator.dart`

```dart
void navigateToPage<T>(BuildContext context, String routeName, {T? data, bool isReplacement = false})
```
- If `isReplacement` is true, uses `context.go(route, extra: data)`
- Otherwise, uses `context.push(route, extra: data)`

See also: [Routing](routing.md).
