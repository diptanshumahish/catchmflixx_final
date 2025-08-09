## Payments

Docs: [Home](README.md) • [Architecture](architecture.md) • [Setup](setup.md) • [Routing](routing.md) • [State](state-management.md) • [API](api.md) • [Models](models.md) • [UI](ui.md) • [Localization](localization.md) • [Error Handling](error-handling.md) • [Player](player.md) • [Payments](payments.md) • [Navigation](navigation.md)

### Capabilities
- Subscription plans and initiation
- Rent options for movies, episodes, seasons
- Multiple providers: PhonePe and Razorpay supported

### API Manager
- `PaymentsManager` (`lib/api/payments/payments.dart`)
  - `getMovieRents`, `getEpisodeRents`, `getSeasonRents`, `getSubscriptions`
  - `phonePeInitMovie`, `phonePeInitEpisode`, `phonePeInitSeason`
  - `rzPayInitMovie`, `razorPeInitEpisode`, `razorPeInitSeason`

### Screens
- `screens/payments/*`: all plans, renting screens (movie/episode/season), web page wrappers

See also: [API Layer](api.md), [Routing](routing.md).
