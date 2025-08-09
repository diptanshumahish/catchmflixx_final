//✅ translated
import 'dart:io';
import 'dart:ui';
import 'package:catchmflixx/state/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:catchmflixx/widgets/navigation/navbar_content.dart';
import 'package:catchmflixx/utils/responsive/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BottomNavbar extends ConsumerWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translation = AppLocalizations.of(context)!;
    // final size = MediaQuery.of(context).size; // Unused
    final textScaler = MediaQuery.textScalerOf(context);
    
    // Calculate responsive height based on font size
    final baseHeight = Platform.isIOS ? 70.0 : 65.0;
    final responsiveHeight = ResponsiveUtils.getResponsiveHeight(
      context,
      baseHeight: baseHeight,
      smallScreenHeight: baseHeight * 0.9,
      largeScreenHeight: baseHeight * 1.2,
    );
    
    // Adjust height for large font sizes using effective scale estimate
    final effectiveScale = textScaler.scale(14.0) / 14.0; // 14 as a common body size
    final adjustedHeight = effectiveScale > 1.2 
        ? responsiveHeight * (1 + (effectiveScale - 1.2) * 0.3)
        : responsiveHeight;
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.getResponsivePadding(
          context,
          basePadding: 16,
          smallScreenPadding: 12,
          largeScreenPadding: 20,
        ),
        vertical: 8,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: adjustedHeight,
            decoration: BoxDecoration(
              color: const Color.fromARGB(180, 20, 20, 22),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SafeArea(
              bottom: Platform.isIOS ? true : false,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: effectiveScale > 1.2 ? 4 : 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NavbarContent(
                      icon: PhosphorIconsDuotone.house,
                      name: translation.navHome,
                      idx: 0,
                    ),
                    NavbarContent(
                      icon: PhosphorIconsDuotone.magnifyingGlass,
                      name: translation.navDiscover,
                      idx: 1,
                    ),
                    NavbarContent(
                      icon: PhosphorIconsDuotone.userCircle,
                      image: (ref.watch(currentProfileProvider)?.avatar) ??
                          "https://img.playbook.com/Axh_gEkgZbsvB1VDuXm4GNvbjXXu2RUUqwToXJEJ8ZQ/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzM5NTk3ODYx/LWQ1MzItNDZmMC1i/ZDhmLTQ2NjRiYjcz/NjZmMQ",
                      name: ref.watch(currentProfileProvider)?.name ?? "user",
                      idx: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
