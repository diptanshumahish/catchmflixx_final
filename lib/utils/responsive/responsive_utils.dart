import 'package:flutter/material.dart';

class ResponsiveUtils {
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 360;
  }

  static bool isMediumScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 360 && width < 600;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600;
  }

  static bool isSmallHeight(BuildContext context) {
    return MediaQuery.of(context).size.height < 700;
  }

  static bool isMediumHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return height >= 700 && height < 900;
  }

  static bool isLargeHeight(BuildContext context) {
    return MediaQuery.of(context).size.height >= 900;
  }

  static double getResponsiveFontSize(BuildContext context, {
    required double baseSize,
    double? smallScreenSize,
    double? largeScreenSize,
  }) {
    if (isSmallScreen(context)) {
      return smallScreenSize ?? (baseSize * 0.85);
    } else if (isLargeScreen(context)) {
      return largeScreenSize ?? (baseSize * 1.1);
    }
    return baseSize;
  }

  static double getResponsivePadding(BuildContext context, {
    required double basePadding,
    double? smallScreenPadding,
    double? largeScreenPadding,
  }) {
    if (isSmallScreen(context)) {
      return smallScreenPadding ?? (basePadding * 0.8);
    } else if (isLargeScreen(context)) {
      return largeScreenPadding ?? (basePadding * 1.2);
    }
    return basePadding;
  }

  static double getResponsiveHeight(BuildContext context, {
    required double baseHeight,
    double? smallScreenHeight,
    double? largeScreenHeight,
  }) {
    if (isSmallHeight(context)) {
      return smallScreenHeight ?? (baseHeight * 0.9);
    } else if (isLargeHeight(context)) {
      return largeScreenHeight ?? (baseHeight * 1.1);
    }
    return baseHeight;
  }

  static EdgeInsets getResponsiveEdgeInsets(BuildContext context, {
    required EdgeInsets basePadding,
    EdgeInsets? smallScreenPadding,
    EdgeInsets? largeScreenPadding,
  }) {
    if (isSmallScreen(context)) {
      return smallScreenPadding ?? EdgeInsets.all(basePadding.left * 0.8);
    } else if (isLargeScreen(context)) {
      return largeScreenPadding ?? EdgeInsets.all(basePadding.left * 1.2);
    }
    return basePadding;
  }
}
