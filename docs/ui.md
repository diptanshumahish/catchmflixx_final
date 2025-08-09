## UI, Theme, Typography, Responsive

Docs: [Home](README.md) • [Architecture](architecture.md) • [Setup](setup.md) • [Routing](routing.md) • [State](state-management.md) • [API](api.md) • [Models](models.md) • [UI](ui.md) • [Localization](localization.md) • [Error Handling](error-handling.md) • [Player](player.md) • [Payments](payments.md) • [Navigation](navigation.md)

### Theme
- `theme/theme_catchmflixx.dart`
  - Material theme with dark color scheme, M3 enabled
  - Page transition builders (Android Zoom, iOS Cupertino)
  - Karla font applied to both Material and Cupertino widgets

### Typography
- `theme/typography.dart`
  - `AppText` widget wraps Flutter `Text` for consistent variants
  - Variants: display, headline, title, sectionTitle, subtitle, body, bodySmall, caption, label
  - Always use `AppText` instead of `Text` to ensure the unified style

### Responsive Utilities
- `utils/responsive/responsive_utils.dart`
- `theme/responsive_theme.dart`
  - Helpers to scale padding, margins, icon sizes, radii, list/grid sizing

### Common Styles
- `constants/styles/text_styles.dart` – legacy/static styles still used in places
- `constants/styles/gradient.dart` – reusable gradient constant

### Widgets
- `widgets/common/` – buttons, cards, inputs, loaders, modals, etc.
- `widgets/home/`, `widgets/content/`, `widgets/player/`, `widgets/payments/`, `widgets/settings/`

### Screens
- `screens/main/*` – Home, Search, Profile, Movie/Series details, etc.
- `screens/start/*` – Splash, onboarding, login/register flows
- `screens/payments/*` – Subscription and renting screens
- `screens/language/*`, `screens/error/*`, `screens/list/*`

### Navigation Shell
- `screens/main/home_main.dart` defines `BaseMain` with tabbed structure and transition animations
