import 'package:flutter/material.dart';
import 'package:catchmflixx/utils/responsive/responsive_utils.dart';

abstract class TextStyles {
  static const double _baseFontSize = 13;
  static const double _smallScreenAdjustment = 2;

  static const headingMobile = TextStyle(
      height: 1.1,
      fontSize: 26,
      color: Colors.white,
      fontWeight: FontWeight.w700);

  static const headingMobileSmallScreens = TextStyle(
      height: 1.1,
      fontSize: 26 - _smallScreenAdjustment,
      color: Colors.white,
      fontWeight: FontWeight.w700);

  static const detailsMobile = TextStyle(
    fontSize: _baseFontSize,
    color: Colors.white60,
  );
  static const formSubTitle = TextStyle(
      fontSize: _baseFontSize, color: Colors.white);
  static const formSubTitleForSmallerScreens = TextStyle(
    fontSize: _baseFontSize - 1,
    color: Colors.white,
  );

  static const textInputText = TextStyle(
    fontSize: _baseFontSize,
    color: Colors.white,
  );
  static const textInputTextForSmallScreens = TextStyle(
    fontSize: _baseFontSize - 1,
    color: Colors.white,
  );

  static const textButton = TextStyle(
    fontSize: _baseFontSize,
    color: Colors.white,
  );
  static const textButtonForSmallerScreens = TextStyle(
    fontSize: _baseFontSize - 1,
    color: Colors.white,
  );

  static const headingsSecondaryMobile = TextStyle(
      fontSize: 24,
      color: Colors.white,
      height: 1.2,
      fontWeight: FontWeight.w600);

  static const headingsSecondaryMobileForSmallerScreens = TextStyle(
    fontSize: 24 - _smallScreenAdjustment,
    color: Colors.white,
    height: 1.2,
    fontWeight: FontWeight.w600,
  );

  static const headingsForSections = TextStyle(
    fontSize: 20,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  static const headingsForSectionsForSmallerScreens = TextStyle(
      fontSize: 20 - _smallScreenAdjustment,
      color: Colors.white,
      fontWeight: FontWeight.w600);

  static const smallSubText = TextStyle(
    fontSize: 12,
    color: Colors.white54,
  );
  static const smallSubTextActive = TextStyle(
    fontSize: 12,
    color: Colors.white,
  );

  static const cardHeading = TextStyle(
    fontSize: 14,
    color: Colors.white,
    height: 1.2,
    fontWeight: FontWeight.w500,
  );
  static const searchBox = TextStyle(
    fontSize: 14,
    color: Colors.white,
    height: 1.2,
  );

  static const cardHeadingForSmallerScreens = TextStyle(
    fontSize: 14 - _smallScreenAdjustment,
    color: Colors.white,
    height: 1.2,
    fontWeight: FontWeight.w500,
  );

  // Responsive text style methods
  static TextStyle getResponsiveHeading(BuildContext context) {
    return TextStyle(
      height: 1.1,
      fontSize: ResponsiveUtils.getResponsiveFontSize(
        context,
        baseSize: 26,
        smallScreenSize: 22,
        largeScreenSize: 28,
      ),
      color: Colors.white,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle getResponsiveDetails(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.getResponsiveFontSize(
        context,
        baseSize: _baseFontSize,
        smallScreenSize: 11,
        largeScreenSize: 14,
      ),
      color: Colors.white60,
    );
  }

  static TextStyle getResponsiveFormSubTitle(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.getResponsiveFontSize(
        context,
        baseSize: _baseFontSize,
        smallScreenSize: 11,
        largeScreenSize: 14,
      ),
      color: Colors.white,
    );
  }

  static TextStyle getResponsiveTextInput(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.getResponsiveFontSize(
        context,
        baseSize: _baseFontSize,
        smallScreenSize: 11,
        largeScreenSize: 14,
      ),
      color: Colors.white,
    );
  }

  static TextStyle getResponsiveTextButton(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.getResponsiveFontSize(
        context,
        baseSize: _baseFontSize,
        smallScreenSize: 11,
        largeScreenSize: 14,
      ),
      color: Colors.white,
    );
  }

  static TextStyle getResponsiveSecondaryHeading(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.getResponsiveFontSize(
        context,
        baseSize: 24,
        smallScreenSize: 20,
        largeScreenSize: 26,
      ),
      color: Colors.white,
      height: 1.2,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle getResponsiveSectionHeading(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.getResponsiveFontSize(
        context,
        baseSize: 20,
        smallScreenSize: 18,
        largeScreenSize: 22,
      ),
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle getResponsiveCardHeading(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.getResponsiveFontSize(
        context,
        baseSize: 14,
        smallScreenSize: 12,
        largeScreenSize: 16,
      ),
      color: Colors.white,
      height: 1.2,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle getResponsiveSearchBox(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.getResponsiveFontSize(
        context,
        baseSize: 14,
        smallScreenSize: 12,
        largeScreenSize: 16,
      ),
      color: Colors.white,
      height: 1.2,
    );
  }

  static TextStyle getResponsiveSmallSubText(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.getResponsiveFontSize(
        context,
        baseSize: 12,
        smallScreenSize: 10,
        largeScreenSize: 13,
      ),
      color: Colors.white54,
    );
  }
}
