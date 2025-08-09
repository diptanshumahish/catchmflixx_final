import 'package:catchmflixx/constants/images.dart';
import 'package:catchmflixx/widgets/content/activity/watch_history_mini.dart';
import 'package:catchmflixx/widgets/content/activity/watch_later_mini.dart';
import 'package:catchmflixx/widgets/home/home_first.dart';
import 'package:catchmflixx/widgets/home/top_bar_banner.dart';
import 'package:catchmflixx/theme/typography.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/responsive/responsive_utils.dart';
// import removed; unified typography handles text sizing
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Modern App Bar with glassmorphism effect
          SliverAppBar.large(
            stretch: true,
            leading: const SizedBox.shrink(),
            expandedHeight: ResponsiveUtils.getResponsiveHeight(
              context,
              baseHeight: 520,
              smallScreenHeight: 460,
              largeScreenHeight: 580,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Animate(
              effects: const [FadeEffect(delay: Duration(milliseconds: 400))],
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  CatchMFlixxImages.textLogo,
                  height: ResponsiveUtils.getResponsiveFontSize(
                    context,
                    baseSize: 30,
                    smallScreenSize: 26,
                    largeScreenSize: 34,
                  ),
                ),
              ),
            ),
            centerTitle: true,
            flexibleSpace: const TopBarBanner(),
          ),
          
          // Main content with improved spacing
          SliverToBoxAdapter(
            child: Animate(
              effects: const [FadeEffect(delay: Duration(milliseconds: 600))],
              child: Container(
                margin: const EdgeInsets.only(top: 20),
              ),
            ),
          ),
          
          const HomeFirst(),
          
          // Enhanced Quick Actions Section
          SliverToBoxAdapter(
            child: Animate(
              effects: const [FadeEffect(delay: Duration(milliseconds: 800))],
              child: Container(
                margin: ResponsiveUtils.getResponsiveEdgeInsets(
                  context,
                  basePadding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                  smallScreenPadding: const EdgeInsets.fromLTRB(16, 25, 16, 16),
                  largeScreenPadding: const EdgeInsets.fromLTRB(24, 35, 24, 24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.orange, Colors.red],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          AppText(
                            "Quick Actions",
                            variant: AppTextVariant.sectionTitle,
                            fontSize: ResponsiveUtils.getResponsiveFontSize(
                              context,
                              baseSize: 20,
                              smallScreenSize: 18,
                              largeScreenSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Enhanced Quick Action Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildEnhancedQuickActionCard(
                            icon: Icons.play_circle_outline,
                            title: "Continue Watching",
                            subtitle: "Pick up where you left off",
                            gradient: [Colors.orange, Colors.deepOrange],
                            onTap: () {
                              navigateToPage(context, "/user/history");
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildEnhancedQuickActionCard(
                            icon: Icons.favorite_border,
                            title: "My List",
                            subtitle: "Your saved content",
                            gradient: [Colors.red, Colors.pink],
                            onTap: () {
                              navigateToPage(context, "/user/watch-list");
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Watch History with improved spacing
          SliverToBoxAdapter(
            child: Animate(
              effects: const [FadeEffect(delay: Duration(milliseconds: 1000))],
              child: Container(
                margin: const EdgeInsets.only(top: 10),
              ),
            ),
          ),
          
          const WatchHistoryComponent(),
          
          // Watch Later with improved spacing
          SliverToBoxAdapter(
            child: Animate(
              effects: const [FadeEffect(delay: Duration(milliseconds: 1200))],
              child: Container(
                margin: const EdgeInsets.only(top: 10),
              ),
            ),
          ),
          
          const WatchLaterComponent(),
          
          // Modern Bottom Spacing
          SliverToBoxAdapter(
            child: Animate(
              effects: const [FadeEffect(delay: Duration(milliseconds: 1400))],
              child: Container(
                margin: const EdgeInsets.only(top: 50, bottom: 120),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 6,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Builder(
        builder: (context) {
          final size = MediaQuery.of(context).size;
          final bool isSmall = size.width < 380;
          final double cardHeight = isSmall ? 140 : 160;
          return Container(
        height: cardHeight,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              gradient[0].withOpacity(0.15),
              gradient[1].withOpacity(0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: gradient[0].withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    gradient[0].withOpacity(0.3),
                    gradient[1].withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: gradient[0].withOpacity(0.4),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: gradient[0],
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            AppText(
              title,
              variant: AppTextVariant.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            AppText(
              subtitle,
              variant: AppTextVariant.body,
              color: Colors.white.withOpacity(0.7),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
        }
      ),
    );
  }
}
