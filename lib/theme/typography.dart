import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppTextVariant {
  display,
  headline,
  title,
  sectionTitle,
  subtitle,
  body,
  bodySmall,
  caption,
  label,
}

class AppTypography {
  static TextStyle styleOf(BuildContext context, AppTextVariant variant) {
    final textScaler = MediaQuery.textScalerOf(context);
    double scaled(double base) {
      final scaledValue = textScaler.scale(base);
      final min = base * 0.85;
      final max = base * 1.25;
      return scaledValue.clamp(min, max);
    }
    TextStyle style;
    switch (variant) {
      case AppTextVariant.display:
        style = TextStyle(
          fontSize: scaled(32),
          fontWeight: FontWeight.w800,
          color: Colors.white,
        );
        break;
      case AppTextVariant.headline:
        style = TextStyle(
          fontSize: scaled(26),
          fontWeight: FontWeight.w700,
          color: Colors.white,
        );
        break;
      case AppTextVariant.title:
        style = TextStyle(
          fontSize: scaled(20),
          fontWeight: FontWeight.w600,
          color: Colors.white,
        );
        break;
      case AppTextVariant.sectionTitle:
        style = TextStyle(
          fontSize: scaled(18),
          fontWeight: FontWeight.w600,
          color: Colors.white,
        );
        break;
      case AppTextVariant.subtitle:
        style = TextStyle(
          fontSize: scaled(16),
          fontWeight: FontWeight.w500,
          color: Colors.white.withOpacity(0.9),
        );
        break;
      case AppTextVariant.body:
        style = TextStyle(
          fontSize: scaled(14),
          fontWeight: FontWeight.w400,
          color: Colors.white,
        );
        break;
      case AppTextVariant.bodySmall:
        style = TextStyle(
          fontSize: scaled(12),
          fontWeight: FontWeight.w400,
          color: Colors.white70,
        );
        break;
      case AppTextVariant.caption:
        style = TextStyle(
          fontSize: scaled(11),
          fontWeight: FontWeight.w500,
          color: Colors.white60,
        );
        break;
      case AppTextVariant.label:
        style = TextStyle(
          fontSize: scaled(10),
          fontWeight: FontWeight.w600,
          color: Colors.white,
        );
        break;
    }
    // Force Karla font regardless of Material/Cupertino app root
    return GoogleFonts.karla(textStyle: style);
  }
}

class AppText extends StatelessWidget {
  final String data;
  final AppTextVariant variant;
  final Color? color;
  final FontWeight? weight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;
  final double? fontSize;

  const AppText(
    this.data, {
    super.key,
    this.variant = AppTextVariant.body,
    this.color,
    this.weight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.height,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle base = AppTypography.styleOf(context, variant);
    base = base.copyWith(
      color: color ?? base.color,
      fontWeight: weight ?? base.fontWeight,
      height: height,
      fontSize: fontSize ?? base.fontSize,
    );

    return Text(
      data,
      style: base,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}


