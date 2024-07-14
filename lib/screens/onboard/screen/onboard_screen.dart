import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/widgets/onboard/login/login_inner_component.dart';
import 'package:catchmflixx/widgets/onboard/onboard_top.dart';
import 'package:catchmflixx/widgets/onboard/register/register_inner_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

int _activeIndex = 0;

final List<Widget> _items = [
  RegisterInner(
    key: GlobalKey(debugLabel: "Register"),
  ),
  LoginInner(
    key: GlobalKey(debugLabel: "Login Screen"),
  )
];

final List<bool> _selector = [true, false];

class OnboardScreen extends StatefulWidget {
  final int? change;
  const OnboardScreen({super.key, this.change = 0});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  @override
  void initState() {
    if (widget.change == 1) {
      setState(() {
        _activeIndex = 1;
        _selector[0] = false;
        _selector[1] = true;
      });
    } else {
      setState(() {
        _activeIndex = 0;
        _selector[0] = true;
        _selector[1] = false;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final translation = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.large(
            stretch: true,
            backgroundColor: Colors.black,
            title: Text(
              translation.register,
              style: TextStyles.cardHeading,
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            expandedHeight: size.height / 3.5,
            flexibleSpace: OnboardTopBar(
              description: "",
              type:
                  _activeIndex == 0 ? translation.register : translation.login,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.height / 40),
              child: ToggleButtons(
                focusColor: Colors.white,
                fillColor: Colors.white24,
                borderRadius: BorderRadius.circular(8),
                constraints: const BoxConstraints(minHeight: 35),
                isSelected: _selector,
                onPressed: (index) {
                  setState(() {
                    if (index == 0) {
                      setState(() {
                        _selector[0] = true;
                        _selector[1] = false;
                        _activeIndex = 0;
                      });
                    } else {
                      setState(() {
                        _selector[0] = false;
                        _selector[1] = true;
                        _activeIndex = 1;
                      });
                    }
                  });
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      translation.register,
                      style: TextStyles.cardHeading,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child:
                        Text(translation.login, style: TextStyles.cardHeading),
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: AnimatedSwitcher(
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOutCubic,
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
                  duration: const Duration(milliseconds: 500),
                  child: _items[_activeIndex]))
        ],
      ),
    );
  }
}
