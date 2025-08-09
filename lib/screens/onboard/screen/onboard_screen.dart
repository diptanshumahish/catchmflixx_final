import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/widgets/onboard/login/login_inner_component.dart';
import 'package:catchmflixx/widgets/onboard/register/register_inner_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

int _activeIndex = 0;

final List<bool> _selector = [true, false];

class OnboardScreen extends StatefulWidget {
  final int? change;
  const OnboardScreen({super.key, this.change = 0});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final List<Widget> _items = [
    RegisterInner(key: GlobalKey(debugLabel: "Register")),
    LoginInner(key: GlobalKey(debugLabel: "Login Screen")),
  ];

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
    final isTablet = size.width >= 600;

    Widget content = Stack(
      children: [
        // Bold gradient image background
        Positioned.fill(
          child: Image.asset(
          'lib/assets/gradient3.jpg',
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            alignment: Alignment.topCenter,
          ),
        ),
        Positioned.fill(
          child: Container(color: Colors.black.withOpacity(0.75)),
        ),
        SafeArea(
          child: Column(
            children: [
              // Minimal top bar
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              // Bottom-anchored content with scroll fallback
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: size.width * 0.995,
                        ),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.01,
                            vertical: isTablet ? 20 : 8,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: constraints.maxHeight),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Center(
                                  child: ToggleButtons(
                                    focusColor: Colors.white,
                                    fillColor: Colors.white12,
                                    borderRadius: BorderRadius.circular(8),
                                    constraints: const BoxConstraints(minHeight: 40),
                                    isSelected: _selector,
                                    onPressed: (index) {
                                      setState(() {
                                        _selector[0] = index == 0;
                                        _selector[1] = index == 1;
                                        _activeIndex = index;
                                      });
                                    },
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Text(
                                          translation.register,
                                          style: TextStyles.cardHeading,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Text(
                                          translation.login,
                                          style: TextStyles.cardHeading,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                AnimatedSwitcher(
                                  switchInCurve: Curves.easeInOut,
                                  switchOutCurve: Curves.easeInOutCubic,
                                  transitionBuilder: (child, animation) {
                                    final animationOffset = animation.drive(Tween(
                                      begin: const Offset(0.06, 0.0),
                                      end: Offset.zero,
                                    ));
                                    return SlideTransition(
                                      position: animationOffset,
                                      child: FadeTransition(opacity: animation, child: child),
                                    );
                                  },
                                  duration: const Duration(milliseconds: 400),
                                  child: _items[_activeIndex],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: content,
    );
  }
}
