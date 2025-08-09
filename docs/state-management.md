## State Management (Riverpod)

Docs: [Home](README.md) • [Architecture](architecture.md) • [Setup](setup.md) • [Routing](routing.md) • [State](state-management.md) • [API](api.md) • [Models](models.md) • [UI](ui.md) • [Localization](localization.md) • [Error Handling](error-handling.md) • [Player](player.md) • [Payments](payments.md) • [Navigation](navigation.md)

Entry: `lib/state/provider.dart`

### Root Providers
- `languageProvider: StateNotifierProvider<LanguageNotifier, lang.Language>`
- `tabsProvider: StateNotifierProvider<TabNotifier, TabSelector>`
- `userLoginProvider: StateNotifierProvider<UserLoginResponseNotifier, UserLoginResponseState>`
- `userRegisterProvider: StateNotifierProvider<RegisterResponseNotifier, RegisterResponseState>`
- `userDetailsProvider: StateNotifierProvider<UserDetailsNotifier, UserDetailsState>`
- `watchHistoryProvider: StateNotifierProvider<UserWatchHistoryNotifier, UserActivityHistory>`
- `watchLaterProvider: StateNotifierProvider<UserWatchLaterNotifier, WatchLaterList>`
- `firstEpProvider: StateNotifierProvider<FirstEpNotifier, List<String>>`
- `userSubscriptionProvider: StateNotifierProvider<UserSubscriptionNotifier, SubscriptionPlans>`
- `currentProfileProvider: StateNotifierProvider<CurrentProfileNotifier, LoggedInCurrentProfile?>`

### Typical Flow
UI reads providers via `ref.watch(...)` → user interactions call notifiers → notifiers call API managers (see [API Layer](api.md)) → models deserialized → state updates → UI rebuilds

### Where to Extend
- Create new feature provider under `lib/state/<feature>/`
- Export/register in `state/provider.dart` if global
- Prefer immutable state classes
