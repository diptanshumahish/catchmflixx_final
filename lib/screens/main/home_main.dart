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
  const BaseMain({super.key});

  @override
  ConsumerState<BaseMain> createState() => _BaseMainState();
}

class _BaseMainState extends ConsumerState<BaseMain> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final activeIndex = ref.watch(tabsProvider);

    return Scaffold(
        backgroundColor: Colors.black,
        body: AnimatedSwitcher(
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            duration:
                const Duration(milliseconds: 400), // Adjust animation duration
            transitionBuilder: (child, animation) {
              final animationOffset = animation.drive(Tween(
                begin: const Offset(1.0, 0.0), // Start from right side
                end: Offset.zero, // Slide to center
              ));
              return SlideTransition(
                position: animationOffset,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: screens[activeIndex.tab]),
        extendBody: true,
        bottomNavigationBar: SizedBox(
          child: Padding(
            padding: EdgeInsets.all(size.height / 50),
            child: const BottomNavbar(),
          ),
        ));
  }
}
