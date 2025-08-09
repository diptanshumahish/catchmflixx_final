import 'package:flutter/material.dart';
import 'package:catchmflixx/utils/responsive/responsive_utils.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final bool useResponsivePadding;
  final bool useResponsiveSize;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.useResponsivePadding = true,
    this.useResponsiveSize = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: useResponsiveSize && width != null
          ? ResponsiveUtils.getResponsiveFontSize(
              context,
              baseSize: width!,
              smallScreenSize: width! * 0.9,
              largeScreenSize: width! * 1.1,
            )
          : width,
      height: useResponsiveSize && height != null
          ? ResponsiveUtils.getResponsiveHeight(
              context,
              baseHeight: height!,
              smallScreenHeight: height! * 0.9,
              largeScreenHeight: height! * 1.1,
            )
          : height,
      padding: useResponsivePadding && padding != null
          ? ResponsiveUtils.getResponsiveEdgeInsets(
              context,
              basePadding: padding!,
            )
          : padding,
      child: child,
    );
  }
}

class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ResponsiveText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class ResponsiveContainer extends StatelessWidget {
  final Widget? child;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final BoxDecoration? decoration;
  final AlignmentGeometry? alignment;

  const ResponsiveContainer({
    super.key,
    this.child,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.decoration,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin != null
          ? ResponsiveUtils.getResponsiveEdgeInsets(
              context,
              basePadding: margin!,
            )
          : null,
      padding: padding != null
          ? ResponsiveUtils.getResponsiveEdgeInsets(
              context,
              basePadding: padding!,
            )
          : null,
      width: width != null
          ? ResponsiveUtils.getResponsiveFontSize(
              context,
              baseSize: width!,
              smallScreenSize: width! * 0.9,
              largeScreenSize: width! * 1.1,
            )
          : null,
      height: height != null
          ? ResponsiveUtils.getResponsiveHeight(
              context,
              baseHeight: height!,
              smallScreenHeight: height! * 0.9,
              largeScreenHeight: height! * 1.1,
            )
          : null,
      decoration: decoration,
      alignment: alignment,
      child: child,
    );
  }
}
