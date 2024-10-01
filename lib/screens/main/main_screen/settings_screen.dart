// ✅ translated

import 'package:catchmflixx/api/auth/auth_manager.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';

// import 'package:catchmflixx/screens/payments/payment_plans_screen.dart';

import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/state/user/login/user.login.response.state.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/widgets/common/Info/info_container.dart';
import 'package:catchmflixx/widgets/common/flex/flex_items.dart';
import 'package:catchmflixx/widgets/settings/settings_button.dart';
// import 'package:catchmflixx/widgets/settings/settings_switch.dart';
import 'package:catchmflixx/widgets/settings/settings_text_button.dart';
import 'package:catchmflixx/widgets/settings/settings_top.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:page_transition/page_transition.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restart_app/restart_app.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

// bool _hapticsEnabled = true;
// bool _updatesReceive = true;
bool _verificationIssue = false;
bool _isEntirelyNew = false;

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void initState() {
    getState();
    super.initState();
  }

  Future<void> getState() async {
    final user = ref.read(userLoginProvider);

    if (user is LoadedUserLoginResponseState &&
        user.userLoginResponse.isLoggedIn!) {
      setState(() {
        _verificationIssue = false;
        _isEntirelyNew = false;
      });
      return;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userState = prefs.getString("temp_login_mail");
      if (userState != null) {
        setState(() {
          _verificationIssue = true;
        });
      } else {
        setState(() {
          _isEntirelyNew = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SettingsTop(
              settingsText: translation.settings,
              settingsSubText: translation.settingsManage),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, bottom: 10, left: 20, right: 20),
              child: FlexItems(widgetList: [
                _verificationIssue
                    ? InfoContainer(
                        data: translation.notVerifiedEM,
                        fn: () {
                          // navigateToPage(context, const LaterVerifyScreen());
                        },
                        action: translation.ver,
                        icon: Icons.verified,
                        color: const Color(0xFF370905))
                    : const SizedBox.shrink(),
                _isEntirelyNew
                    ? InfoContainer(
                        data: translation.notSignIn,
                        fn: () {
                          navigateToPage(context, "/onboard");
                        },
                        action: translation.loginOrRegister,
                        icon: Icons.person,
                        color: const Color.fromARGB(255, 55, 38, 5))
                    : const SizedBox.shrink(),
                Text(
                  translation.accountSettings,
                  style: TextStyles.smallSubText,
                ),
                // SettingsButton(
                //     headingName: translation.pricingPlans,
                //     subHeading: translation.checkPlans,
                //     icon: PhosphorIconsDuotone.money,
                //     fn: () {
                //       navigateToPage(context, const PaymentsPlansScreen());
                //     }),
                SettingsButton(
                    headingName: translation.profilemanagement,
                    subHeading: translation.settingsEditProfile,
                    icon: PhosphorIconsDuotone.users,
                    fn: () {
                      if (_verificationIssue == false &&
                          _isEntirelyNew == false) {
                        navigateToPage(context, "/user/profile-management");

                        return;
                      }
                      if (_isEntirelyNew == true) {
                        navigateToPage(context, "/onboard");
                      }
                    }),
                SettingsButton(
                    headingName: translation.settingsLanguage,
                    subHeading: translation.settingsLangChose,
                    icon: PhosphorIconsDuotone.translate,
                    fn: () {
                      navigateToPage(context, "/languages");
                    }),
                  
                // SettingsButton(
                //     headingName: translation.prefferedGenres,
                //     subHeading: translation.chooseGenres,
                //     icon: PhosphorIconsDuotone.option,
                //     fn: () {
                //       navigateToPage(context, const ChooseGenresScreen());
                //     }),
                // const Divider(
                //   color: Colors.white30,
                // ),
                // Text(
                //   translation.exp,
                //   style: TextStyles.smallSubText,
                // ),
                // SettingsSwitch(
                //     heading: translation.settingshaptics,
                //     subHeading: translation.settingschose,
                //     switchBool: _hapticsEnabled,
                //     fn: (val) {
                //       setState(() {
                //         _hapticsEnabled = val;
                //       });
                //     }),
                // SettingsSwitch(
                //     heading: translation.settingsreceive,
                //     subHeading: translation.settingsUpdates,
                //     switchBool: _updatesReceive,
                //     fn: (val) {
                //       setState(() {
                //         _updatesReceive = val;
                //       });
                //     }),
              ], space: 2),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(
                color: Colors.white30,
              ),
            ),
          ),
          SettingsTextButton(
              content: translation.settingsSwitchProfile,
              icon: PhosphorIconsDuotone.userSwitch,
              fn: () {
                if (!_isEntirelyNew && !_verificationIssue) {
                  navigateToPage(context, "/check-login", isReplacement: true);
                }
              },
              color: Colors.orangeAccent),
          SettingsTextButton(
              content: translation.logout,
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
          SettingsTextButton(
              content: translation.requestAccountDeletion,
              icon: PhosphorIconsDuotone.trashSimple,
              fn: () async {},
              color: Colors.red),
          SettingsTextButton(
              content: translation.support,
              icon: PhosphorIconsDuotone.lifebuoy,
              fn: () async {
                await launchUrl(Uri.parse("mailto:support@catchmflix.com"));
              },
              color: Colors.white),
          SettingsTextButton(
              content: translation.suggestionsForUs,
              icon: PhosphorIconsDuotone.smiley,
              fn: () async {
                await launchUrl(Uri.parse("mailto:support@catchmflix.com"));
              },
              color: Colors.white),
          SettingsTextButton(
              content: translation.termsAndConditions,
              icon: PhosphorIconsDuotone.note,
              fn: () async {
                await launchUrl(
                    Uri.parse("https://www.catchmflixx.com/en/terms"));
              },
              color: Colors.white),
          SettingsTextButton(
              content: translation.privacyPolicy,
              icon: PhosphorIconsDuotone.keyhole,
              fn: () async {
                await launchUrl(
                    Uri.parse("https://www.catchmflixx.com/en/privacy-policy"));
              },
              color: Colors.white),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
            ),
          ),
        ],
      ),
    );
  }
}
