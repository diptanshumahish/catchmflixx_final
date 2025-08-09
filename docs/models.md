## Models

Docs: [Home](README.md) • [Architecture](architecture.md) • [Setup](setup.md) • [Routing](routing.md) • [State](state-management.md) • [API](api.md) • [Models](models.md) • [UI](ui.md) • [Localization](localization.md) • [Error Handling](error-handling.md) • [Player](player.md) • [Payments](payments.md) • [Navigation](navigation.md)

Location: `lib/models/`

### Major Groups
- `ads/` – Ad-related responses
- `cast/` – Cast lists
- `content/` – Content discovery and details
  - `movie/` – `movie.model.dart` full details
  - `series/` – seasons, episodes, continue watching
  - `genres.dart`, `search.list.model.dart`
- `error/` – Error payloads (`error_model.dart`, `typo_error_model.dart`)
- `language/` – `lang.model.dart`, `language.model.dart`
- `message/` – Generic message envelope (`message_model.dart`)
- `payments/` – Subscription and rent models
- `profiles/` – Profiles list, current profile, avatars
- `tabs/` – Tab selector model for bottom nav
- `user/` – Login/register/reset/details and `maxlimit.response.model.dart`
- `version/` – Version info for upgrade checks

### Conventions
- Prefer `fromJson`/`fromMap` factory constructors
- Keep types nullable where server may omit fields
- Group feature-specific models together for discoverability
