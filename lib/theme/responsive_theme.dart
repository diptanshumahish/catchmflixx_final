import 'package:flutter/material.dart';
import 'package:catchmflixx/utils/responsive/responsive_utils.dart';

class ResponsiveTheme {
  // Responsive spacing
  static EdgeInsets getResponsivePadding(BuildContext context) {
    return ResponsiveUtils.getResponsiveEdgeInsets(
      context,
      basePadding: const EdgeInsets.all(16),
      smallScreenPadding: const EdgeInsets.all(12),
      largeScreenPadding: const EdgeInsets.all(20),
    );
  }

  static EdgeInsets getResponsiveMargin(BuildContext context) {
    return ResponsiveUtils.getResponsiveEdgeInsets(
      context,
      basePadding: const EdgeInsets.all(16),
      smallScreenPadding: const EdgeInsets.all(12),
      largeScreenPadding: const EdgeInsets.all(20),
    );
  }

  // Responsive border radius
  static BorderRadius getResponsiveBorderRadius(BuildContext context) {
    const baseRadius = 12.0;
    return BorderRadius.circular(
      ResponsiveUtils.getResponsiveFontSize(
        context,
        baseSize: baseRadius,
        smallScreenSize: baseRadius * 0.8,
        largeScreenSize: baseRadius * 1.2,
      ),
    );
  }

  // Responsive icon size
  static double getResponsiveIconSize(BuildContext context) {
    return ResponsiveUtils.getResponsiveFontSize(
      context,
      baseSize: 24,
      smallScreenSize: 20,
      largeScreenSize: 28,
    );
  }

  // Responsive button height
  static double getResponsiveButtonHeight(BuildContext context) {
    return ResponsiveUtils.getResponsiveHeight(
      context,
      baseHeight: 48,
      smallScreenHeight: 44,
      largeScreenHeight: 52,
    );
  }

  // Responsive card height
  static double getResponsiveCardHeight(BuildContext context) {
    return ResponsiveUtils.getResponsiveHeight(
      context,
      baseHeight: 200,
      smallScreenHeight: 180,
      largeScreenHeight: 220,
    );
  }

  // Responsive app bar height
  static double getResponsiveAppBarHeight(BuildContext context) {
    return ResponsiveUtils.getResponsiveHeight(
      context,
      baseHeight: 56,
      smallScreenHeight: 52,
      largeScreenHeight: 64,
    );
  }

  // Responsive bottom navigation height
  static double getResponsiveBottomNavHeight(BuildContext context) {
    return ResponsiveUtils.getResponsiveHeight(
      context,
      baseHeight: 80,
      smallScreenHeight: 70,
      largeScreenHeight: 90,
    );
  }

  // Responsive spacing values
  static double getResponsiveSpacing(BuildContext context, {
    required double baseSpacing,
    double? smallScreenSpacing,
    double? largeScreenSpacing,
  }) {
    return ResponsiveUtils.getResponsiveFontSize(
      context,
      baseSize: baseSpacing,
      smallScreenSize: smallScreenSpacing ?? (baseSpacing * 0.8),
      largeScreenSize: largeScreenSpacing ?? (baseSpacing * 1.2),
    );
  }

  // Responsive grid spacing
  static double getResponsiveGridSpacing(BuildContext context) {
    return ResponsiveUtils.getResponsiveFontSize(
      context,
      baseSize: 16,
      smallScreenSize: 12,
      largeScreenSize: 20,
    );
  }

  // Responsive list spacing
  static double getResponsiveListSpacing(BuildContext context) {
    return ResponsiveUtils.getResponsiveFontSize(
      context,
      baseSize: 8,
      smallScreenSize: 6,
      largeScreenSize: 12,
    );
  }

  // Responsive section spacing
  static double getResponsiveSectionSpacing(BuildContext context) {
    return ResponsiveUtils.getResponsiveFontSize(
      context,
      baseSize: 24,
      smallScreenSize: 20,
      largeScreenSize: 32,
    );
  }

  // Responsive content spacing
  static double getResponsiveContentSpacing(BuildContext context) {
    return ResponsiveUtils.getResponsiveFontSize(
      context,
      baseSize: 16,
      smallScreenSize: 12,
      largeScreenSize: 20,
    );
  }

  // Responsive image aspect ratio
  static double getResponsiveImageAspectRatio(BuildContext context) {
    if (ResponsiveUtils.isSmallScreen(context)) {
      return 16 / 9; // Wider for small screens
    } else if (ResponsiveUtils.isLargeScreen(context)) {
      return 4 / 3; // More square for large screens
    }
    return 3 / 2; // Default aspect ratio
  }

  // Responsive card aspect ratio
  static double getResponsiveCardAspectRatio(BuildContext context) {
    if (ResponsiveUtils.isSmallScreen(context)) {
      return 2 / 3; // Taller for small screens
    } else if (ResponsiveUtils.isLargeScreen(context)) {
      return 3 / 4; // More square for large screens
    }
    return 2 / 3; // Default aspect ratio
  }

  // Responsive grid cross axis count
  static int getResponsiveGridCrossAxisCount(BuildContext context) {
    if (ResponsiveUtils.isSmallScreen(context)) {
      return 2; // 2 columns for small screens
    } else if (ResponsiveUtils.isLargeScreen(context)) {
      return 4; // 4 columns for large screens
    }
    return 3; // 3 columns for medium screens
  }

  static double getResponsiveListItemHeight(BuildContext context) {
    return ResponsiveUtils.getResponsiveHeight(
      context,
      baseHeight: 80,
      smallScreenHeight: 70,
      largeScreenHeight: 90,
    );
  }

  static double getResponsiveDialogWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (ResponsiveUtils.isSmallScreen(context)) {
      return screenWidth * 0.9; // 90% of screen width
    } else if (ResponsiveUtils.isLargeScreen(context)) {
      return screenWidth * 0.6; // 60% of screen width
    }
    return screenWidth * 0.8; // 80% of screen width
  }

  static double getResponsiveModalHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    if (ResponsiveUtils.isSmallHeight(context)) {
      return screenHeight * 0.7; // 70% of screen height
    } else if (ResponsiveUtils.isLargeHeight(context)) {
      return screenHeight * 0.5; // 50% of screen height
    }
    return screenHeight * 0.6; // 60% of screen height
  }
}
