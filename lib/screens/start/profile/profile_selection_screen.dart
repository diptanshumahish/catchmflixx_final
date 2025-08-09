import 'package:catchmflixx/theme/typography.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/widgets/common/buttons/secondary_full_button.dart';
import 'package:catchmflixx/models/profiles/profile.model.dart';
import 'package:catchmflixx/widgets/profile/profile_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilesSelection extends ConsumerWidget {
  final ProfilesList profiles;
  const ProfilesSelection(this.profiles, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translation = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              AppText(
                translation.whosWatching,
                variant: AppTextVariant.headline,
                color: Colors.white,
                weight: FontWeight.w800,
                fontSize: 28,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 3),
              AppText(
                translation.chooseProfile,
                variant: AppTextVariant.body,
                color: Colors.white70,
                fontSize: 14,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.separated(
                  itemCount: profiles.data!.length,
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final profile = profiles.data![index];
                    return ProfileTapWidget(profile: profile);
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SecondaryFullButton(
                      content: translation.addnewProfile,
                      icon: const Icon(Icons.add, size: 18, color: Colors.white),
                      fn: () => navigateToPage(context, "/user/profile-management"),
                      notFull: true,
                    ),
                  ),
               
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileTapWidget extends StatefulWidget {
  final dynamic profile;

  const ProfileTapWidget({super.key, required this.profile});

  @override
  State<ProfileTapWidget> createState() => _ProfileTapWidgetState();
}

class _ProfileTapWidgetState extends State<ProfileTapWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  void _pressStart() {
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
  }

  void _pressEnd() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _pressStart(),
      onPointerUp: (_) => _pressEnd(),
      onPointerCancel: (_) => _pressEnd(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12, width: 1),
                ),
                child: Opacity(
                  opacity: _isPressed ? 0.9 : 1.0,
                  child: ProfileIcon(
                    hash: widget.profile.hash ?? "",
                    isProtected: widget.profile.is_protected ?? false,
                    uniqueId: widget.profile.uuid ?? "",
                    isAdult:
                        widget.profile.profile_type == "Adult" ? true : false,
                    avatar: widget.profile.avatar,
                    profileName: widget.profile.name ?? "",
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
