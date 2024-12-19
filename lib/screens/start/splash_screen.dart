import 'dart:async';
import 'package:catchmflixx/constants/images.dart';
import 'package:catchmflixx/constants/text.dart';

import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:catchmflixx/utils/version/version_check.dart';
import 'package:catchmflixx/widgets/common/loading/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _loading = true;
  int max_tries = 3;

  @override
  void initState() {
    Timer(const Duration(seconds: 4), () {
      checkData();
    });
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _loading = false;
      });
    });
  }

  checkData() async {
    if (max_tries == 0) {
      navigateToPage(context, "/error");
      return null;
    }
    if (!mounted) return null;
    if(max_tries>0){
      try {
      final data = await isVersionUpToDate();
      if (data == true) {
        if (mounted) {
          navigateToPage(context, "/check-login", isReplacement: true);
        }
        return null;
      } else {
        if (mounted) {
          navigateToPage(
            context,
            "/version",
          );
          return null;
        }
      }
    } catch (e) {
      max_tries--;
      await Future.delayed(const Duration(seconds: 2));
      ToastShow.returnToast(
          "Error in newtork, retrying ($max_tries attempt remaining) ");
      debugPrint(e.toString());
      await checkData();
    }
    }
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
              child: SafeArea(
                bottom: true,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                    child: Column(
                      children: [
                        CoolLoadingIndicator(),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Loading",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "version ${ConstantTexts.versionInfo}",
                          style: TextStyle(color: Colors.white30),
                        )
                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
