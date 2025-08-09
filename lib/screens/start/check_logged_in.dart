
// imports trimmed for a simpler design

// Removed unused: auth_manager
import 'package:catchmflixx/api/user/profile/profile_api.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
// Removed unused: verify_email
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/state/user/login/user.login.response.state.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_full_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
// Removed unused: shared_preferences
import 'package:upgrader/upgrader.dart';

class CheckLoggedIn extends ConsumerStatefulWidget {
  const CheckLoggedIn({super.key});

  @override
  ConsumerState<CheckLoggedIn> createState() => _CheckLoggedInState();
}

class _CheckLoggedInState extends ConsumerState<CheckLoggedIn>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  // state kept minimal

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userLoginProvider);
    final size = MediaQuery.of(context).size;
    final translation = AppLocalizations.of(context)!;

    return UpgradeAlert(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          bottom: true,
          top: false,
          child: Stack(
            children: [
              // Gradient background similar to login/register screens
              Positioned.fill(
                child: Image.asset(
                  'lib/assets/gradient1.jpg',
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  alignment: Alignment.topCenter,
                ),
              ),
              Positioned.fill(
                child: Container(color: Colors.black.withOpacity(0.65)),
              ),
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: size.height * 0.55,
                      child: Center(
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'CatchMflixx',
                                  textAlign: TextAlign.center,
                                  style: TextStyles.headingMobile.copyWith(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.1,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  'Your Entertainment Hub',
                                  style: TextStyles.smallSubText.copyWith(
                                    fontSize: 16,
                                    color: Colors.white70,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 20),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    fillOverscroll: true,
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: (user is LoadedUserLoginResponseState &&
                              !(user.userLoginResponse.isLoggedIn ?? false))
                          ? _buildLoginSection(translation)
                          : _buildWelcomeBackSection(translation),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginSection(AppLocalizations translation) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Clean welcome text
            Text(
              translation.login,
              style: TextStyles.headingMobile.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Welcome to CatchMflix, login or register to continue',
              style: TextStyles.smallSubText.copyWith(
                fontSize: 14,
                color: Colors.white60,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Clean buttons
            Animate(
              effects: const [
                FadeEffect(delay: Duration(milliseconds: 200)),
                SlideEffect(
                  begin: Offset(0, 0.2),
                  duration: Duration(milliseconds: 500),
                ),
              ],
              child: OffsetFullButton(
                content: translation.login,
                icon: Icons.account_circle,
                fn: () => navigateToPage(context, "/onboard/1"),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Animate(
              effects: const [
                FadeEffect(delay: Duration(milliseconds: 400)),
                SlideEffect(
                  begin: Offset(0, 0.2),
                  duration: Duration(milliseconds: 500),
                ),
              ],
              child: OffsetFullButton(
                content: translation.register,
                icon: PhosphorIconsBold.book,
                fn: () => navigateToPage(context, "/onboard/0"),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeBackSection(AppLocalizations translation) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Clean welcome back section
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF986E).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.celebration,
                    color: Color(0xFFFF986E),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translation.welcomeBack,
                        style: TextStyles.headingMobile.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        translation.selectProfileNext,
                        style: TextStyles.smallSubText.copyWith(
                          fontSize: 14,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 40),
            
            Animate(
              effects: const [
                FadeEffect(delay: Duration(milliseconds: 300)),
                SlideEffect(
                  begin: Offset(0, 0.2),
                  duration: Duration(milliseconds: 500),
                ),
              ],
              child: OffsetFullButton(
                content: translation.continueTo,
                icon: Icons.view_stream,
                fn: () async {
                  ProfileApi pro = ProfileApi();
                  try {
                    final res = await pro.fetchProfiles();
                    if (!mounted) return;
                    navigateToPage(
                      context,
                      "/user/profile-selection",
                      data: res,
                      isReplacement: true,
                    );
                  } catch (e) {
                    ToastShow.returnToast(e.toString());
                  }
                },
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Removed gradient text/divider/border helpers as per design preference

// Removed previous custom painter in favor of image-based gradient background
