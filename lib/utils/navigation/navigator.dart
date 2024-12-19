import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void navigateToPage<T>(
  BuildContext context,
  String routeName, {
  T? data,
  bool isReplacement = false,
}) {
  if (isReplacement) {
    context.go(routeName, extra: data);
  } else {
    context.push(routeName, extra: data);
  }
}
