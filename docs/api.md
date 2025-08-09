## API Layer

Docs: [Home](README.md) • [Architecture](architecture.md) • [Setup](setup.md) • [Routing](routing.md) • [State](state-management.md) • [API](api.md) • [Models](models.md) • [UI](ui.md) • [Localization](localization.md) • [Error Handling](error-handling.md) • [Player](player.md) • [Payments](payments.md) • [Navigation](navigation.md)

### Overview
Dio-based clients with cookie persistence, per-request token injection, auto-refresh on 401, and unified error handling via toasts.

### Clients
- `NetworkManager` (`lib/api/common/network.dart`)
  - Base URLs: `https://api.catchmflixx.com/api/` (primary) and `https://www.catchmflixx.com/api/` (secondary)
  - Interceptors: Cookie jar, user-agent, dynamic bearer header
  - Language helper: `getLang()` reads `APP_LANG`
  - `makeRequest<T>(endpoint, fromJson, method = GET, data?, useSecondaryDio?)`
    - Handles 401 via `APIManager.refreshToken()`
- `WebNetworkManager` (`lib/api/common/web_network.dart`)

### Feature Managers
- Auth: `APIManager` (`lib/api/auth/auth_manager.dart`)
- Content: `ContentManager` (`lib/api/content/common.dart`)
- Payments: `PaymentsManager` (`lib/api/payments/payments.dart`) – see also [Payments](payments.md)
- Version: `VersionManager` (`lib/api/version/version_check.dart`)

### Error Handling
- Network-level errors mapped to toasts; API payloads parsed as `MessageModel` where applicable. See [Error Handling](error-handling.md).

### Authentication
- Bearer stored in SharedPreferences `bearer`
- On 401 → refresh via `APIManager.refreshToken()`; on failure triggers logout

### Models
- Located under `lib/models/*`. See [Models](models.md).
