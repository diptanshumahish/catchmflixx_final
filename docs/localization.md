## Localization (i18n)

Docs: [Home](README.md) • [Architecture](architecture.md) • [Setup](setup.md) • [Routing](routing.md) • [State](state-management.md) • [API](api.md) • [Models](models.md) • [UI](ui.md) • [Localization](localization.md) • [Error Handling](error-handling.md) • [Player](player.md) • [Payments](payments.md) • [Navigation](navigation.md)

### Supported Locales
Defined in `utils/app/app_config.dart`:
- `en`, `hi`, `kn`, `ml`, `te`, `ta`

### Setup
- `flutter_localizations` and generated `AppLocalizations` are wired via `AppConfig`.
- Use `AppLocalizations.of(context)!` to access translations in widgets.
- ARB files live in `lib/l10n`: `app_en.arb`, `app_hi.arb`, `app_kn.arb`, `app_ml.arb`, `app_ta.arb`, `app_te.arb`.

### Locale Selection
- Language is handled by `languageProvider` (Riverpod), returning a `Locale`.
- `CatchMFlixxApp` reads the language and passes it to `AppConfig.buildApp()`.
- `AppConfig.validateLocale` ensures unsupported locales fall back to English.

### Adding a New Language
1. Add an ARB file under `lib/l10n/app_<code>.arb`
2. Add the locale to `AppConfig.supportedLocales`
3. Regenerate l10n: `flutter gen-l10n`
4. Provide UI to switch language using the `languageProvider`
