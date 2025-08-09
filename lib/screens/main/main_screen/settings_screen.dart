
import 'dart:io';

import 'package:catchmflixx/api/auth/auth_manager.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/state/user/login/user.login.response.state.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/terminate.dart';
// Removed unused UI imports after migrating to unified typography
import 'package:catchmflixx/widgets/settings/settings_top.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:catchmflixx/theme/typography.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

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
    final UrlLauncherPlatform launcher = UrlLauncherPlatform.instance;

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SettingsTop(
              settingsText: translation.settings,
              settingsSubText: translation.settingsManage),
          
          // Status Alerts Section
          if (_verificationIssue || _isEntirelyNew)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    if (_verificationIssue)
                      _buildStatusCard(
                        icon: Icons.verified,
                        title: translation.notVerifiedEM,
                        action: translation.ver,
                        color: const Color(0xFF370905),
                        onAction: () {
                          // navigateToPage(context, const LaterVerifyScreen());
                        },
                      ),
                    if (_isEntirelyNew)
                      _buildStatusCard(
                        icon: Icons.person,
                        title: translation.notSignIn,
                        action: translation.loginOrRegister,
                        color: const Color.fromARGB(255, 55, 38, 5),
                        onAction: () {
                          navigateToPage(context, "/onboard");
                        },
                      ),
                  ],
                ),
              ),
            ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: _buildSettingsSection(
                title: translation.accountSettings,
                children: [
                  _buildSettingsCard(
                    icon: PhosphorIconsDuotone.users,
                    title: translation.profilemanagement,
                    subtitle: translation.settingsEditProfile,
                    onTap: () {
                      if (_verificationIssue == false && _isEntirelyNew == false) {
                        navigateToPage(context, "/user/profile-management");
                        return;
                      }
                      if (_isEntirelyNew == true) {
                        navigateToPage(context, "/onboard");
                      }
                    },
                  ),
                  _buildSettingsCard(
                    icon: PhosphorIconsDuotone.translate,
                    title: translation.settingsLanguage,
                    subtitle: translation.settingsLangChose,
                    onTap: () {
                      navigateToPage(context, "/languages");
                    },
                  ),
                ],
              ),
            ),
          ),

          // Account Actions Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: _buildSettingsSection(
                title: "Account Actions",
                children: [
                  _buildSettingsCard(
                    icon: PhosphorIconsDuotone.userSwitch,
                    title: translation.settingsSwitchProfile,
                    subtitle: "Switch to a different profile",
                    onTap: () {
                      if (!_isEntirelyNew && !_verificationIssue) {
                        navigateToPage(context, "/check-login", isReplacement: true);
                      }
                    },
                    isDestructive: false,
                  ),
                  _buildSettingsCard(
                    icon: PhosphorIconsDuotone.exclude,
                    title: translation.logout,
                    subtitle: "Sign out of your account",
                    onTap: () async {
                      SharedPreferences sp = await SharedPreferences.getInstance();
                      APIManager api = APIManager();
                      await api.useLogout();
                      bool cleared = await sp.clear();
                      if (cleared) {
                        closeApp();
                      }
                    },
                    isDestructive: true,
                  ),
                  _buildSettingsCard(
                    icon: PhosphorIconsDuotone.trashSimple,
                    title: translation.requestAccountDeletion,
                    subtitle: "Permanently delete your account",
                    onTap: () async {
                      if (Platform.isIOS) {
                        launcher.launch("https://catchmflixx.com/en/delete-account",
                            useSafariVC: true,
                            enableDomStorage: false,
                            enableJavaScript: true,
                            useWebView: true,
                            headers: {},
                            universalLinksOnly: false);
                      } else {
                        await launchUrl(Uri.parse("https://catchmflixx.com/en/delete-account"));
                      }
                    },
                    isDestructive: true,
                  ),
                ],
              ),
            ),
          ),

          // Support & Legal Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: _buildSettingsSection(
                title: "Support & Legal",
                children: [
                  _buildSettingsCard(
                    icon: PhosphorIconsDuotone.lifebuoy,
                    title: translation.support,
                    subtitle: "Get help and contact support",
                    onTap: () async {
                      if (Platform.isIOS) {
                        launcher.launch("https://catchmflixx.com/en",
                            useSafariVC: true,
                            enableDomStorage: false,
                            enableJavaScript: true,
                            useWebView: true,
                            headers: {},
                            universalLinksOnly: false);
                      } else {
                        await launchUrl(Uri.parse("mailto:support@catchmflix.com"));
                      }
                    },
                  ),
                  _buildSettingsCard(
                    icon: PhosphorIconsDuotone.smiley,
                    title: translation.suggestionsForUs,
                    subtitle: "Share your feedback with us",
                    onTap: () async {
                      if (Platform.isIOS) {
                        launcher.launch("https://catchmflixx.com/en",
                            useSafariVC: true,
                            enableDomStorage: false,
                            enableJavaScript: true,
                            useWebView: true,
                            headers: {},
                            universalLinksOnly: false);
                      } else {
                        await launchUrl(Uri.parse("mailto:support@catchmflix.com"));
                      }
                    },
                  ),
                  _buildSettingsCard(
                    icon: PhosphorIconsDuotone.note,
                    title: translation.termsAndConditions,
                    subtitle: "Read our terms of service",
                    onTap: () async {
                      if (Platform.isIOS) {
                        launcher.launch("https://www.catchmflixx.com/en/terms",
                            useSafariVC: true,
                            enableDomStorage: false,
                            enableJavaScript: true,
                            useWebView: true,
                            headers: {},
                            universalLinksOnly: false);
                      } else {
                        await launchUrl(Uri.parse("https://www.catchmflixx.com/en/terms"));
                      }
                    },
                  ),
                  _buildSettingsCard(
                    icon: PhosphorIconsDuotone.keyhole,
                    title: translation.privacyPolicy,
                    subtitle: "Read our privacy policy",
                    onTap: () async {
                      if (Platform.isIOS) {
                        launcher.launch("https://www.catchmflixx.com/en/privacy-policy",
                            useSafariVC: true,
                            enableDomStorage: false,
                            enableJavaScript: true,
                            useWebView: true,
                            headers: {},
                            universalLinksOnly: false);
                      } else {
                        await launchUrl(Uri.parse("https://www.catchmflixx.com/en/privacy-policy"));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard({
    required IconData icon,
    required String title,
    required String action,
    required Color color,
    required VoidCallback onAction,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(title, variant: AppTextVariant.subtitle),
                const SizedBox(height: 4),
                AppText(action, variant: AppTextVariant.caption, color: color),
              ],
            ),
          ),
          IconButton(
            onPressed: onAction,
            icon: Icon(Icons.arrow_forward_ios, color: color, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDestructive 
                    ? Colors.red.withOpacity(0.2)
                    : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red : Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title,
                    variant: AppTextVariant.subtitle,
                    color: isDestructive ? Colors.red : Colors.white,
                    weight: FontWeight.w600,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    subtitle,
                    variant: AppTextVariant.body,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
