import 'package:catchmflixx/models/profiles/profile.model.dart';
import 'package:catchmflixx/models/user/maxlimit.response.model.dart';
import 'package:catchmflixx/screens/error/error_screen.dart';
import 'package:catchmflixx/screens/language/language_screen.dart';
import 'package:catchmflixx/screens/list/history_list.dart';
import 'package:catchmflixx/screens/list/my_to_watch_list.dart';
import 'package:catchmflixx/screens/main/home_main.dart';
import 'package:catchmflixx/screens/main/main_screen/settings_screen.dart';
import 'package:catchmflixx/screens/main/movie_screens/movie_screen.dart';
import 'package:catchmflixx/screens/main/series/series_screen.dart';
import 'package:catchmflixx/screens/onboard/error/max_login.dart';
import 'package:catchmflixx/screens/onboard/screen/onboard_screen.dart';
import 'package:catchmflixx/screens/payments/all_plans_screen.dart';
import 'package:catchmflixx/screens/payments/episode_renting_screen.dart';
import 'package:catchmflixx/screens/payments/payment_success.dart';
import 'package:catchmflixx/screens/payments/renting_screen.dart';
import 'package:catchmflixx/screens/payments/season_renting_screen.dart';
import 'package:catchmflixx/screens/payments/web_page.dart';
import 'package:catchmflixx/screens/profile/profile_management.screen.dart';
import 'package:catchmflixx/screens/redirects/redirect_screen.dart';
import 'package:catchmflixx/screens/start/check_logged_in.dart';
import 'package:catchmflixx/screens/start/profile/edit_profile.dart';
import 'package:catchmflixx/screens/start/profile/profile_selection_screen.dart';
import 'package:catchmflixx/screens/start/splash_screen.dart';
import 'package:catchmflixx/screens/start/verify_email.dart';
import 'package:catchmflixx/screens/version/version_screen.dart';
import 'package:catchmflixx/utils/protection/secure_screen_wrapper.dart';
import 'package:catchmflixx/widgets/common/CFXModal/custom_modal.dart';
import 'package:catchmflixx/widgets/onboard/forgot/forgot_password.dart';
import 'package:catchmflixx/widgets/player/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter appRoute = GoRouter(
  initialLocation: "/",
  routes: <RouteBase>[
    GoRoute(
      path: "/",
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: '/payment-make',
      builder: (context, state) {
        return const BaseMain();
      },
    ),
    GoRoute(
      path: '/web-view',
      builder: (context, state) {
        final String url = state.extra as String;

        return WebPage(url: url);
      },
    ),
    GoRoute(
      path: '/error',
      builder: (BuildContext context, GoRouterState state) {
        return const ErrorScreen();
      },
    ),
    GoRoute(
      path: '/en/payment-success',
      builder: (BuildContext context, GoRouterState state) {
        return const PaymentSuccessScreen();
      },
    ),
    GoRoute(
      path: "/forgot-password",
      builder: (BuildContext context, GoRouterState state) {
        return const ForgotPasswordScreen();
      },
    ),
    GoRoute(path: "/", builder: (context, state) => const BaseMain(), routes: [
      GoRoute(
        path: '/en/watch/watch-now/movie',
        builder: (context, state) {
          final movieId = state.uri.queryParameters["id"];
          return MovieScreen(uuid: movieId ?? "");
        },
      ),
      GoRoute(
        path: '/en/watch/watch-now/series',
        builder: (context, state) {
          final sId = state.uri.queryParameters["id"];
          return SeriesScreen(uuid: sId ?? '');
        },
      ),
    ]),
    GoRoute(
      path: '/en/sign-in-app/success',
      builder: (context, state) {
        final aId = state.uri.queryParameters["accessToken"];
        final token = state.uri.queryParameters["idToken"];
        return RedirectScreen(
          idToken: token.toString(),
          accessToken: aId.toString(),
        );
      },
    ),
    GoRoute(
      path: "/splash",
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: "/base",
      builder: (BuildContext context, GoRouterState state) {
        return const BaseMain();
      },
    ),
    GoRoute(
      path: "/max-login",
      builder: (BuildContext context, GoRouterState state) {
        // Handle optional MaxLimit data
        final MaxLimit? limit = state.extra as MaxLimit?;
        return MaxLogin(limit: limit!);
      },
    ),
    GoRoute(
      path: "/movie/:uuid",
      builder: (BuildContext context, GoRouterState state) {
        final String? uuid = state.pathParameters['uuid'];
        return MovieScreen(uuid: uuid ?? '');
      },
    ),
    GoRoute(
      path: "/series/:uuid",
      builder: (BuildContext context, GoRouterState state) {
        // Retrieve query parameters
        final String? uuid = state.pathParameters['uuid'];
        return SeriesScreen(uuid: uuid ?? '');
      },
    ),
    GoRoute(
      path: "/user/history",
      builder: (BuildContext context, GoRouterState state) {
        return const HistoryListWidget();
      },
    ),
    GoRoute(
      path: "/user/watch-list",
      builder: (BuildContext context, GoRouterState state) {
        return const MyToWatchList();
      },
    ),
    GoRoute(
      path: "/check-login",
      builder: (BuildContext context, GoRouterState state) {
        return const CheckLoggedIn();
      },
    ),
    GoRoute(
      path: "/onboard/:key",
      builder: (BuildContext context, GoRouterState state) {
        final String uuid = state.pathParameters['key'] ?? "0";
        return OnboardScreen(
          change: int.parse(uuid),
        );
      },
    ),
    GoRoute(
      path: "/user/profile-management",
      builder: (BuildContext context, GoRouterState state) {
        return const ProfileManagement();
      },
    ),
    GoRoute(
      path: "/languages",
      builder: (BuildContext context, GoRouterState state) {
        return const LanguageScreen();
      },
    ),
    GoRoute(
      path: "/player",
      builder: (BuildContext context, GoRouterState state) {
        final PlayerScreen? data = state.extra as PlayerScreen?;
        return SecureScreenWrapper(
          child: PlayerScreen(
              seekTo: data!.seekTo ?? 0,
              title: data.title,
              details: data.details,
              playLink: data.playLink,
              id: data.id,
              type: data.type,
              act: data.act),
        );
      },
    ),
    GoRoute(
      path: "/user/profile/edit",
      builder: (BuildContext context, GoRouterState state) {
        final EditProfile? data = state.extra as EditProfile?;
        return EditProfile(
            profileId: data!.profileId,
            avatar: data.avatar,
            avatarId: data.avatarId,
            profileName: data.profileName);
      },
    ),
    GoRoute(
      path: "/verify/email",
      builder: (BuildContext context, GoRouterState state) {
        final VerifyEmail data = state.extra as VerifyEmail;
        return VerifyEmail(emailId: data.emailId, password: data.password);
      },
    ),
    GoRoute(
      path: "/user/profile-selection",
      builder: (BuildContext context, GoRouterState state) {
        final ProfilesList data = state.extra as ProfilesList;
        return ProfilesSelection(data);
      },
    ),
    GoRoute(
      path: "/version",
      builder: (BuildContext context, GoRouterState state) {
        return const VersionScreen();
      },
    ),
    GoRoute(
      path: "/plans",
      builder: (BuildContext context, GoRouterState state) {
        return const AllPlansScreen();
      },
    ),
    GoRoute(
      path: "/custom-modal",
      builder: (BuildContext context, GoRouterState state) {
        final CustomModal data = state.extra as CustomModal;
        return CustomModal(
            mainMessage: data.mainMessage,
            detailedMessage: data.detailedMessage,
            primaryFunction: data.primaryFunction,
            primary: data.primary);
      },
    ),
    GoRoute(
      path: "/movie-rent",
      builder: (BuildContext context, GoRouterState state) {
        final RentingScreen data = state.extra as RentingScreen;
        return RentingScreen(
            act: data.act, title: data.title, img: data.img, id: data.id);
      },
    ),
    GoRoute(
      path: "/episode-rent",
      builder: (BuildContext context, GoRouterState state) {
        final EpisodeRentingScreen data = state.extra as EpisodeRentingScreen;
        return EpisodeRentingScreen(
          act: data.act,
          title: data.title,
          img: data.img,
          id: data.id,
          episodeNumber: data.episodeNumber,
        );
      },
    ),
    GoRoute(
      path: "/season-renting",
      builder: (BuildContext context, GoRouterState state) {
        final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        return SeasonRentingScreen(
          act: data['act'] as VoidCallback,
          title: data['title'] as String,
          img: data['img'] as String,
          id: data['id'] as String,
          seasonNumber: data['seasonNumber'] as String,
        );
      },
    ),
    GoRoute(
      path: "/settings",
      builder: (BuildContext context, GoRouterState state) {
        return const SettingsScreen();
      },
    ),
  ],
);
