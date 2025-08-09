import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:catchmflixx/api/content/common.dart';
import 'package:catchmflixx/constants/images.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/models/content/search.list.model.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/responsive/responsive_utils.dart';
// import 'package:catchmflixx/widgets/common/buttons/offset_full_button.dart';
import 'package:catchmflixx/theme/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer/shimmer.dart';

class TopBarBanner extends ConsumerStatefulWidget {
  const TopBarBanner({super.key});

  @override
  ConsumerState<TopBarBanner> createState() => _TopBarBannerState();
}

class _TopBarBannerState extends ConsumerState<TopBarBanner> {
  bool _isReady = false;
  ContentList _cList = ContentList();

  Future<void> getData() async {
    ContentManager ct = ContentManager();
    ContentList? data = await ct.searchContent("");
    if (data != null && data.results?.success == true) {
      setState(() {
        _cList = data;
        _isReady = true;
      });
    }
  }

  int randomNo(int maxLength) {
    Random random = Random();
    return random.nextInt(maxLength);
  }

  @override
  void initState() {
    super.initState();
    getData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userSubscriptionProvider.notifier).updateState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final rand = randomNo(_cList.results?.data?.length ?? 1);
    final size = MediaQuery.of(context).size;

    final subscriptionData = ref.watch(userSubscriptionProvider);
    final currentPlan = subscriptionData.data.isNotEmpty
        ? subscriptionData.data.firstWhere(
            (plan) => plan.current,
            orElse: () => subscriptionData.data.first,
          )
        : null;

    // Whether user is subscribed can be derived when needed
    final isAndroid = Platform.isAndroid;
    // final shouldShowSubscribeBtn = isAndroid && !isSubscribed;

    if (_isReady) {
      return FlexibleSpaceBar(
        background: Stack(
          children: [
            // Hero background with dynamic gradient
            Animate(
              effects: const [FadeEffect(duration: Duration(milliseconds: 1200))],
              child: Container(
                height: 600,
                width: size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      _cList.results?.data?[rand].thumbnail ??
                          "https://img.playbook.com/Axh_gEkgZbsvB1VDuXm4GNvbjXXu2RUUqwToXJEJ8ZQ/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzM5NTk3ODYx/LWQ1MzItNDZmMC1i/ZDhmLTQ2NjRiYjcz/NjZmMQ",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(0.8),
                        Colors.black,
                      ],
                      stops: const [0.0, 0.3, 0.6, 0.85, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            
            // Floating action elements
            Positioned(
              top: ResponsiveUtils.getResponsivePadding(context, basePadding: 80),
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side - Logo
                  Animate(
                    effects: const [
                      FadeEffect(delay: Duration(milliseconds: 300)),
                      SlideEffect(
                        begin: Offset(-0.3, 0),
                        duration: Duration(milliseconds: 500),
                      ),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: SvgPicture.asset(
                          CatchMFlixxImages.textLogo,
                          height: ResponsiveUtils.getResponsiveFontSize(
                            context,
                            baseSize: 24,
                            smallScreenSize: 20,
                            largeScreenSize: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Right side - Subscription badge (Android only)
                  if (isAndroid)
                    Animate(
                      effects: const [
                        FadeEffect(delay: Duration(milliseconds: 500)),
                        SlideEffect(
                          begin: Offset(0.3, 0),
                          duration: Duration(milliseconds: 500),
                        ),
                      ],
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: GestureDetector(
                          onTap: () => navigateToPage(context, "/plans"),
                                                     child: Container(
                             padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                             decoration: BoxDecoration(
                               gradient: LinearGradient(
                                 colors: currentPlan?.name.toLowerCase() == "free" || currentPlan == null
                                     ? [
                                         Colors.white.withOpacity(0.4),
                                         Colors.white.withOpacity(0.2),
                                       ]
                                     : [
                                         Colors.white.withOpacity(0.5),
                                         Colors.white.withOpacity(0.3),
                                       ],
                                 begin: Alignment.topLeft,
                                 end: Alignment.bottomRight,
                               ),
                               borderRadius: BorderRadius.circular(22),
                               border: Border.all(
                                 color: Colors.white.withOpacity(0.5),
                                 width: 1.5,
                               ),
                               boxShadow: [
                                 BoxShadow(
                                   color: Colors.black.withOpacity(0.3),
                                   blurRadius: 8,
                                   offset: const Offset(0, 2),
                                 ),
                               ],
                             ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                                                 Icon(
                                   currentPlan?.name.toLowerCase() == "free"
                                       ? PhosphorIconsLight.sparkle
                                       : PhosphorIconsLight.sketchLogo,
                                   color: Colors.white,
                                   size: 18,
                                 ),
                                const SizedBox(width: 8),
                                  AppText(
                                    currentPlan?.name == "Free" ? "Subscribe" : currentPlan?.name ?? "Free",
                                    variant: AppTextVariant.subtitle,
                                    color: Colors.white,
                                    weight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Content showcase
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                      Colors.black,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                                         // Featured badge
                     Animate(
                       effects: const [
                         FadeEffect(delay: Duration(milliseconds: 600)),
                         ScaleEffect(
                           begin: Offset(0.8, 0.8),
                           duration: Duration(milliseconds: 400),
                         ),
                       ],
                       child: Container(
                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                         decoration: BoxDecoration(
                           color: Colors.white.withOpacity(0.2),
                           borderRadius: BorderRadius.circular(12),
                           border: Border.all(
                             color: Colors.white.withOpacity(0.4),
                             width: 1,
                           ),
                         ),
                          child: const AppText(
                            "FEATURED",
                            variant: AppTextVariant.label,
                          ),
                       ),
                     ),
                    
                    const SizedBox(height: 12),
                    
                    // Title with enhanced styling
                    Animate(
                      effects: const [
                        FadeEffect(delay: Duration(milliseconds: 700)),
                        SlideEffect(
                          begin: Offset(0, 0.3),
                          duration: Duration(milliseconds: 600),
                        ),
                      ],
                      child: Text(
                        _cList.results?.data?[rand].metaData?.title ?? "",
                        style: TextStyles.getResponsiveHeading(context).copyWith(
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                            context,
                            baseSize: 28,
                            smallScreenSize: 24,
                            largeScreenSize: 32,
                          ),
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.1,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Description with better readability
                    Animate(
                      effects: const [
                        FadeEffect(delay: Duration(milliseconds: 800)),
                        SlideEffect(
                          begin: Offset(0, 0.3),
                          delay: Duration(milliseconds: 200),
                          duration: Duration(milliseconds: 600),
                        ),
                      ],
                      child: Text(
                        _cList.results?.data?[rand].metaData?.description ?? "",
                        style: TextStyles.getResponsiveDetails(context).copyWith(
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                            context,
                            baseSize: 14,
                            smallScreenSize: 12,
                            largeScreenSize: 16,
                          ),
                          color: Colors.white.withOpacity(0.9),
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Enhanced watch button
                    Animate(
                      effects: const [
                        FadeEffect(delay: Duration(milliseconds: 900)),
                        ScaleEffect(
                          begin: Offset(0.9, 0.9),
                          duration: Duration(milliseconds: 500),
                        ),
                      ],
                      child: GestureDetector(
                        onTap: () {
                          navigateToPage(
                            context,
                            _cList.results?.data?[rand].type == "movie"
                                ? "/movie/${_cList.results?.data?[rand].uuid ?? ""}"
                                : "/series/${_cList.results?.data?[rand].uuid ?? ""}",
                          );
                        },
                                                 child: Container(
                           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                           decoration: BoxDecoration(
                             gradient: const LinearGradient(
                               colors: [
                                 Colors.white,
                                 Color(0xFFF5F5F5),
                               ],
                               begin: Alignment.topLeft,
                               end: Alignment.bottomRight,
                             ),
                             borderRadius: BorderRadius.circular(30),
                             boxShadow: [
                               BoxShadow(
                                 color: Colors.black.withOpacity(0.3),
                                 blurRadius: 12,
                                 offset: const Offset(0, 4),
                               ),
                             ],
                           ),
                                                       child: const Row(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 Icon(
                                   PhosphorIconsBold.play,
                                   color: Colors.black,
                                   size: 20,
                                 ),
                                 SizedBox(width: 10),
                                  AppText(
                                    "Watch Now",
                                    variant: AppTextVariant.subtitle,
                                    color: Colors.black,
                                    weight: FontWeight.w700,
                                  ),
                               ],
                             ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return FlexibleSpaceBar(
        background: Container(
          height: 500,
          width: size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1A1A1A),
                Color(0xFF0F0F0F),
                Color(0xFF050505),
              ],
            ),
          ),
          child: Center(
            child: Animate(
              effects: const [FadeEffect(duration: Duration(milliseconds: 800))],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.transparent,
                    highlightColor: Colors.white.withOpacity(0.2),
                    child: SvgPicture.asset(
                      CatchMFlixxImages.textLogo,
                      height: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        baseSize: 32,
                        smallScreenSize: 28,
                        largeScreenSize: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const CupertinoActivityIndicator(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Loading amazing content...",
                    style: TextStyles.getResponsiveDetails(context).copyWith(
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
