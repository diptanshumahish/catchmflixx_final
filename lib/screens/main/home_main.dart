import 'package:catchmflixx/screens/main/main_screen/home_screen.dart';
import 'package:catchmflixx/screens/main/main_screen/profile_home_screen.dart';
import 'package:catchmflixx/screens/main/main_screen/search_screen.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/widgets/navigation/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final List<Widget> screens = [
  const HomeScreen(
    key: Key("HOME"),
  ),
  const SearchScreen(
    key: Key("SEARCH"),
  ),
  const ProfileScreen(
    key: Key("SETTINGS"),
  )
];

class BaseMain extends ConsumerStatefulWidget {
  final Widget? child; // Allow nested ShellRoute pages
  const BaseMain({super.key, this.child});

  @override
  ConsumerState<BaseMain> createState() => _BaseMainState();
}

class _BaseMainState extends ConsumerState<BaseMain> {
  @override
  Widget build(BuildContext context) {
    final activeIndex = ref.watch(tabsProvider);

    if (widget.child != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: widget.child,
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedSwitcher(
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) {
          final animationOffset = animation.drive(Tween(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ));
          return SlideTransition(
            position: animationOffset,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: screens[activeIndex.tab],
      ),
      extendBody: true,
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
