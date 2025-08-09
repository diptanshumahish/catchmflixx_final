## Player

Docs: [Home](README.md) • [Architecture](architecture.md) • [Setup](setup.md) • [Routing](routing.md) • [State](state-management.md) • [API](api.md) • [Models](models.md) • [UI](ui.md) • [Localization](localization.md) • [Error Handling](error-handling.md) • [Player](player.md) • [Payments](payments.md) • [Navigation](navigation.md)

### Components
- `widgets/player/player_screen.dart` – Player entry widget (navigated to via `/player`)
- `widgets/player/player_packages/lib/...` – Embedded YoYo player fork with controllers, quality picker, speed, zoom, top/bottom bars, loading UI

### Routing
- Route `/player` expects `state.extra` to contain a `PlayerScreen` instance.
- Wrapped in `SecureScreenWrapper` to prevent screenshots/recording.

See also: [Routing](routing.md), [UI](ui.md).
