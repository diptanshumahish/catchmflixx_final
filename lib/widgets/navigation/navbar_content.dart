import 'package:cached_network_image/cached_network_image.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/utils/vibrate/vibrations.dart';
import 'package:catchmflixx/utils/responsive/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NavbarContent extends ConsumerStatefulWidget {
  final IconData icon;
  final String name;
  final int idx;
  final String? image;
  const NavbarContent({
    super.key,
    this.image,
    required this.icon,
    required this.name,
    required this.idx,
  });

  @override
  ConsumerState<NavbarContent> createState() => _NavbarContentState();
}

class _NavbarContentState extends ConsumerState<NavbarContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void onLanguageChange(int idx) {
    ref.read(tabsProvider.notifier).updateTab(idx);
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = ref.watch(tabsProvider);
    final isSelected = selectedTab.tab == widget.idx;
    final textScaler = MediaQuery.textScalerOf(context);
    
    final baseFontSize = isSelected ? 10.0 : 9.0;
    final responsiveFontSize = ResponsiveUtils.getResponsiveFontSize(
      context,
      baseSize: baseFontSize,
      smallScreenSize: baseFontSize * 0.9,
      largeScreenSize: baseFontSize * 1.1,
    );
    
    // Compute an effective scale for the label size and cap the final scaled size
    final scaledLabelSize = textScaler.scale(responsiveFontSize);
    final maxScaledLabelSize = responsiveFontSize * 1.5;
    final adjustedFontSize = scaledLabelSize > maxScaledLabelSize
        ? responsiveFontSize * (maxScaledLabelSize / scaledLabelSize)
        : responsiveFontSize;

    // Approximate scale factor for making layout decisions (padding/icon sizes)
    final effectiveTextScale = textScaler.scale(responsiveFontSize) / responsiveFontSize;
    
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      onTap: () async {
        await vibrateTap();
        onLanguageChange(widget.idx);
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: effectiveTextScale > 1.2 ? 8 : 12,
                  vertical: effectiveTextScale > 1.2 ? 4 : 6,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.idx == 2)
                      Container(
                        width: effectiveTextScale > 1.2 ? 22 : 26,
                        height: effectiveTextScale > 1.2 ? 22 : 26,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected 
                                ? Colors.white 
                                : Colors.white.withOpacity(0.6),
                            width: isSelected ? 2.5 : 2,
                          ),
                          borderRadius: BorderRadius.circular(
                            effectiveTextScale > 1.2 ? 11 : 13,
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ] : null,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            effectiveTextScale > 1.2 ? 9 : 11,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: widget.image ??
                                "https://img.playbook.com/Axh_gEkgZbsvB1VDuXm4GNvbjXXu2RUUqwToXJEJ8ZQ/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzM5NTk3ODYx/LWQ1MzItNDZmMC1i/ZDhmLTQ2NjRiYjcz/NjZmMQ",
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey.withOpacity(0.3),
                              child: Icon(
                                Icons.person, 
                                size: effectiveTextScale > 1.2 ? 12 : 14, 
                                color: Colors.white70
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey.withOpacity(0.3),
                              child: Icon(
                                Icons.error, 
                                size: effectiveTextScale > 1.2 ? 12 : 14, 
                                color: Colors.white70
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: EdgeInsets.all(effectiveTextScale > 1.2 ? 2 : 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.2),
                              blurRadius: 6,
                              spreadRadius: 0.5,
                            ),
                          ] : null,
                        ),
                        child: PhosphorIcon(
                          widget.icon,
                          size: isSelected 
                              ? (effectiveTextScale > 1.2 ? 20 : 24)
                              : (effectiveTextScale > 1.2 ? 18 : 22),
                          duotoneSecondaryColor: isSelected 
                              ? Colors.white 
                              : Colors.white.withOpacity(0.7),
                          color: isSelected 
                              ? Colors.white 
                              : Colors.white.withOpacity(0.7),
                        ),
                      ),
                    SizedBox(height: effectiveTextScale > 1.2 ? 2 : 3),
                    Flexible(
                      child: Text(
                        widget.name,
                        style: TextStyle(
                          fontSize: adjustedFontSize,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                          color: isSelected 
                              ? Colors.white 
                              : Colors.white.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    if (isSelected)
                      Container(
                        margin: EdgeInsets.only(top: effectiveTextScale > 1.2 ? 0.5 : 1),
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
