import 'dart:async';

import 'package:catchmflixx/constants/images.dart';
import 'package:catchmflixx/constants/text.dart';
import 'package:catchmflixx/screens/start/check_logged_in.dart';
import 'package:catchmflixx/widgets/common/loader_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _loading = true;

  @override
  void initState() {
    Timer(const Duration(seconds: 4), () {
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              child: const CheckLoggedIn(),
              type: PageTransitionType.fade,
              curve: Curves.easeInCubic),
          (route) => false);
    });
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Animate(
                      effects: const [
                        FadeEffect(
                            curve: Curves.easeInOut,
                            delay: Duration(milliseconds: 100))
                      ],
                      child: Image.asset(
                          height: 80, width: 80, CatchMFlixxImages.logo)),
                  const SizedBox(
                    height: 10,
                  ),
                  _loading
                      ? Shimmer.fromColors(
                          baseColor: Colors.transparent,
                          highlightColor: Colors.white,
                          period: const Duration(seconds: 2),
                          child: SvgPicture.asset(
                            CatchMFlixxImages.textLogo,
                            height: 30,
                          ),
                        )
                      : Animate(
                          effects: const [FadeEffect()],
                          child: SvgPicture.asset(
                            CatchMFlixxImages.textLogo,
                            height: 30,
                          ),
                        ),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 10,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: Column(
                    children: [
                      LoaderSpinner(),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Loading",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        ConstantTexts.versionInfo,
                        style: TextStyle(color: Colors.white30),
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
