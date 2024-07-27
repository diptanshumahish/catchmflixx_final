import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

void navigateToPage(
  BuildContext context,
  Widget childPage, {
  PageTransitionType transitionType = PageTransitionType.fade,
  bool isReplacement = false,
  bool removeUntil = false,
  RoutePredicate? predicate,
  Duration duration = const Duration(milliseconds: 400),
  Curve curve = Curves.bounceInOut,
}) {
  final pageTransition = PageTransition(
    duration: duration,
    curve: curve,
    child: childPage,
    type: transitionType,
  );

  if (Platform.isIOS) {
    final iosPageRoute = CupertinoPageRoute(builder: (ctx) => childPage);

    if (removeUntil && predicate != null) {
      Navigator.pushAndRemoveUntil(context, iosPageRoute, predicate);
    } else if (isReplacement) {
      Navigator.pushReplacement(context, iosPageRoute);
    } else {
      Navigator.push(context, iosPageRoute);
    }
  } else {
    if (removeUntil && predicate != null) {
      Navigator.pushAndRemoveUntil(context, pageTransition, predicate);
    } else if (isReplacement) {
      Navigator.pushReplacement(context, pageTransition);
    } else {
      Navigator.push(context, pageTransition);
    }
  }
}
