import 'package:catchmflixx/api/auth/auth_manager.dart';
// unified typography used across app
import 'package:catchmflixx/constants/text.dart';
import 'package:catchmflixx/models/payments/subscription_model.dart';
import 'package:catchmflixx/models/profiles/logged_in_current_profile.model.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/terminate.dart';
import 'package:catchmflixx/widgets/ads/ads_module.dart';
import 'package:catchmflixx/widgets/content/activity/watch_later_mini.dart';
import 'package:catchmflixx/widgets/content/activity/watch_history_mini.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:catchmflixx/theme/typography.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  LoggedInCurrentProfile _currentProfile = LoggedInCurrentProfile();
  final GlobalKey _historyKey = GlobalKey();
  final GlobalKey _myListKey = GlobalKey();
  final GlobalKey _accountKey = GlobalKey();
  
  Future<void> getData() async {
    await ref.read(currentProfileProvider.notifier).refresh();
    final profile = ref.read(currentProfileProvider);
    if (mounted) {
      setState(() {
        _currentProfile = profile ?? LoggedInCurrentProfile();
      });
    }
    await ref.read(userSubscriptionProvider.notifier).updateState();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionState = ref.watch(userSubscriptionProvider);
    final currentPlan = subscriptionState.data.firstWhere(
      (p) => p.current,
      orElse: () => Daum(
        id: 0,
        name: 'Free',
        price: '0',
        maxProfiles: 1,
        current: true,
        validity_days: 0,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.black,
        onRefresh: getData,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.black,
              elevation: 0,
              centerTitle: false,
              titleSpacing: 20,
              toolbarHeight: 72,
              title: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE50914),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: _currentProfile.avatar != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Image.network(
                              _currentProfile.avatar!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                PhosphorIconsBold.user,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          )
                        : const Icon(
                            PhosphorIconsBold.user,
                            color: Colors.white,
                            size: 22,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          _currentProfile.name ?? "Profile",
                          variant: AppTextVariant.subtitle,
                          weight: FontWeight.w700,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00D4AA).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFF00D4AA).withOpacity(0.4), width: 1),
                          ),
                          child: AppText(
                            currentPlan.name,
                            variant: AppTextVariant.caption,
                            color: const Color(0xFF00D4AA),
                            weight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () => navigateToPage(context, "/settings"),
                  icon: const Icon(PhosphorIconsDuotone.gear, color: Colors.white),
                  tooltip: 'Settings',
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => navigateToPage(context, "/user/profile-management"),
                  icon: const Icon(PhosphorIconsDuotone.users, color: Colors.white),
                  tooltip: 'Manage Profiles',
                ),
                const SizedBox(width: 12),
              ],
            ),
            // Quick Actions
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'Quick Actions',
                      variant: AppTextVariant.body,
                      color: Colors.white70,
                      weight: FontWeight.w700,
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _buildQuickAction(
                            icon: PhosphorIconsBold.clock,
                            label: 'History',
                            onTap: () => _scrollTo(_historyKey),
                          ),
                          _buildQuickAction(
                            icon: PhosphorIconsBold.heart,
                            label: 'My List',
                            onTap: () => _scrollTo(_myListKey),
                          ),
                          _buildQuickAction(
                            icon: PhosphorIconsBold.creditCard,
                            label: 'Plans',
                            onTap: () => navigateToPage(context, "/plans"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        // Watch History Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              key: _historyKey,
              child: _buildSettingsSection(
                title: "Watch History",
                actionText: 'View All',
                onAction: () => navigateToPage(context, "/user/history"),
                children: [
                  _buildSettingsCard(
                    icon: PhosphorIconsBold.clock,
                    title: "Continue Watching",
                    subtitle: "Pick up where you left off",
                    onTap: () => navigateToPage(context, "/user/history"),
                  ),
                ],
              ),
            ),
          ),
        ),

        const WatchHistoryComponent(),

        // My List Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              key: _myListKey,
              child: _buildSettingsSection(
                title: "My List",
                actionText: 'View All',
                onAction: () => navigateToPage(context, "/user/watch-list"),
                children: [
                  _buildSettingsCard(
                    icon: PhosphorIconsBold.heart,
                    title: "Saved Content",
                    subtitle: "All the content you saved",
                    onTap: () => navigateToPage(context, "/user/watch-list"),
                  ),
                ],
              ),
            ),
          ),
        ),

        const WatchLaterComponent(),

        // Ads Section
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: AdsModule(),
          ),
        ),

        // Account Actions Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              key: _accountKey,
              child: _buildSettingsSection(
                title: "Account Actions",
                children: [
                  _buildSettingsCard(
                    icon: PhosphorIconsDuotone.gear,
                    title: "App Settings",
                    subtitle: "Manage your app preferences",
                    onTap: () => navigateToPage(context, "/settings"),
                  ),
                  _buildSettingsCard(
                    icon: PhosphorIconsDuotone.userSwitch,
                    title: "Switch Profile",
                    subtitle: "Change to another profile",
                    onTap: () => navigateToPage(context, "/check-login", isReplacement: true),
                  ),
                  _buildSettingsCard(
                    icon: PhosphorIconsDuotone.creditCard,
                    title: "Change Plan",
                    subtitle: "Upgrade your subscription",
                    onTap: () => navigateToPage(context, "/plans"),
                  ),
                  _buildSettingsCard(
                    icon: PhosphorIconsDuotone.exclude,
                    title: "Logout",
                    subtitle: "Sign out of your account",
                    onTap: _confirmLogout,
                    isDestructive: true,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Footer
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        PhosphorIconsBold.heart,
                        color: Color(0xFFE50914),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      AppText(
                        "version ${ConstantTexts.versionInfo}",
                        variant: AppTextVariant.body,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                AppText(
                  "Made with 💖 by the CatchMFlixx team",
                  variant: AppTextVariant.bodySmall,
                  color: Colors.white.withOpacity(0.5),
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
  ),
);
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Expanded(
                child: AppText(
                  title,
                  variant: AppTextVariant.body,
                  color: Colors.white70,
                  weight: FontWeight.w700,
                ),
              ),
              if (actionText != null && onAction != null)
                TextButton(
                  onPressed: onAction,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white70,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  child: Row(
                    children: [
                      AppText(actionText, variant: AppTextVariant.caption, color: Colors.white70),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white54),
                    ],
                  ),
                ),
            ],
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
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
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

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 8),
                AppText(
                  label,
                  variant: AppTextVariant.caption,
                  color: Colors.white,
                  weight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _scrollTo(GlobalKey key) async {
    final context = key.currentContext;
    if (context == null) return;
    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      alignment: 0.05,
    );
  }

  Future<void> _confirmLogout() async {
    HapticFeedback.selectionClick();
    final shouldLogout = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.black,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.25)),
                      ),
                      child: const Icon(PhosphorIconsDuotone.exclude, color: Colors.red, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: AppText(
                        'Sign out?',
                        variant: AppTextVariant.title,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                AppText(
                  'You will need to log in again to continue.',
                  variant: AppTextVariant.body,
                  color: Colors.white70,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white.withOpacity(0.2)),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const AppText('Cancel', variant: AppTextVariant.subtitle),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const AppText('Logout', variant: AppTextVariant.subtitle),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (shouldLogout == true) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      APIManager api = APIManager();
      await api.useLogout();
      bool cleared = await sp.clear();
      if (cleared) {
        closeApp();
      }
    }
  }
}
