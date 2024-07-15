import 'package:flutter/material.dart';

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
    fontFamily: "Kollektif",
  );
  static const formSubTitle = TextStyle(
      fontSize: _baseFontSize, color: Colors.white, fontFamily: "Kollektif");
  static const formSubTitleForSmallerScreens =
      TextStyle(fontSize: _baseFontSize - 1, color: Colors.white);

  static const textInputText = TextStyle(
    fontSize: _baseFontSize,
    color: Colors.white,
    fontFamily: "Kollektif",
  );
  static const textInputTextForSmallScreens = TextStyle(
    fontSize: _baseFontSize - 1,
    color: Colors.white,
    fontFamily: "Kollektif",
  );

  static const textButton = TextStyle(
    fontSize: _baseFontSize,
    color: Colors.white,
    fontFamily: "Kollektif",
  );
  static const textButtonForSmallerScreens = TextStyle(
    fontSize: _baseFontSize - 1,
    color: Colors.white,
    fontFamily: "Kollektif",
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
    fontFamily: "Kollektif",
  );

  static const headingsForSections = TextStyle(
    fontSize: 20,
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontFamily: "Kollektif",
  );

  static const headingsForSectionsForSmallerScreens = TextStyle(
      fontSize: 20 - _smallScreenAdjustment,
      color: Colors.white,
      fontWeight: FontWeight.w600);

  static const smallSubText = TextStyle(fontSize: 12, color: Colors.white54);
  static const smallSubTextActive =
      TextStyle(fontSize: 12, color: Colors.white);

  static const cardHeading = TextStyle(
    fontSize: 14,
    color: Colors.white,
    height: 1.2,
    fontWeight: FontWeight.w500,
    fontFamily: "Kollektif",
  );
  static const searchBox = TextStyle(
    fontSize: 14,
    color: Colors.white,
    fontFamily: "Kollektif",
    letterSpacing: 0.5,
    height: 1.2,
  );

  static const cardHeadingForSmallerScreens = TextStyle(
      fontSize: 14 - _smallScreenAdjustment,
      color: Colors.white,
      height: 1.2,
      fontWeight: FontWeight.w500);
}
