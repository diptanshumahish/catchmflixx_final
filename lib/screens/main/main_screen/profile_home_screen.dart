import 'package:catchmflixx/api/auth/auth_manager.dart';
import 'package:catchmflixx/api/user/profile/profile_api.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/constants/text.dart';
import 'package:catchmflixx/models/profiles/logged_in_current_profile.model.dart';
import 'package:catchmflixx/state/provider.dart';

import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/widgets/ads/ads_module.dart';
import 'package:catchmflixx/widgets/content/activity/watch_later_mini.dart';

import 'package:catchmflixx/widgets/content/activity/watch_history_mini.dart';
import 'package:catchmflixx/widgets/profile/render/profile_top.dart';
import 'package:catchmflixx/widgets/settings/settings_button.dart';
import 'package:catchmflixx/widgets/settings/settings_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

LoggedInCurrentProfile _currentProfile = LoggedInCurrentProfile();

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  getData() async {
    ProfileApi p = ProfileApi();
    final data = await p.getCurrentProfile();
    setState(() {
      _currentProfile = data;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          leading: SizedBox.shrink(),
          title: Text(
            "My CatchMFlixx",
            style: TextStyles.headingsForSections,
          ),
          backgroundColor: Colors.black,
        ),
        ProfileTop(
          settingsText: _currentProfile.name ?? "Profile",
          settingsSubText: "manage your personal stuff",
          image: _currentProfile.avatar,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Animate(
              effects: const [FadeEffect(delay: Duration(milliseconds: 300))],
              child: SettingsButton(
                  headingName: "Watch history",
                  subHeading: "Check out your watch history",
                  icon: PhosphorIconsBold.arrowUpRight,
                  fn: () {
                    navigateToPage(context, "/user/history");
                  }),
            ),
          ),
        ),
        const WatchHistoryComponent(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Animate(
              effects: const [FadeEffect(delay: Duration(milliseconds: 400))],
              child: SettingsButton(
                  headingName: "My list",
                  subHeading: "All the content you saved",
                  icon: PhosphorIconsBold.arrowUpRight,
                  fn: () {
                    navigateToPage(context, "/user/watch-list");
                  }),
            ),
          ),
        ),
        const WatchLaterComponent(),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: AdsModule(),
          ),
        ),
        SettingsTextButton(
            content: "Switch profile",
            icon: PhosphorIconsDuotone.userSwitch,
            fn: () {
             
              navigateToPage(context, "/check-login", isReplacement: true);
            },
            color: Colors.orangeAccent),
        SettingsTextButton(
            content: "Logout",
            icon: PhosphorIconsDuotone.exclude,
            fn: () async {
              SharedPreferences sp = await SharedPreferences.getInstance();
              APIManager api = APIManager();
              await api.useLogout();
              bool cleared = await sp.clear();
              if (cleared) {
                Restart.restartApp();
              }
            },
            color: Colors.red),
        SliverToBoxAdapter(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: size.width / 20, vertical: 10),
            child: const Text(
              "version ${ConstantTexts.versionInfo}, made with 💖 by the CatchMFlixx team",
              style: TextStyles.smallSubText,
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 200,
          ),
        ),
      ],
    );
  }
}
