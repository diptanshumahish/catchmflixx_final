// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:catchmflixx/api/auth/auth_manager.dart';
import 'package:catchmflixx/api/user/profile/profile_api.dart';
import 'package:catchmflixx/constants/images.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/screens/start/verify_email.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/state/user/login/user.login.response.state.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_full_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

class CheckLoggedIn extends ConsumerStatefulWidget {
  const CheckLoggedIn({super.key});

  @override
  ConsumerState<CheckLoggedIn> createState() => _CheckLoggedInState();
}

class _CheckLoggedInState extends ConsumerState<CheckLoggedIn> {
  @override
  void initState() {
    getHalfLoggedInState();
    super.initState();
  }

  Future<void> getHalfLoggedInState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? isNotVerified = prefs.getString("temp_login_mail");
    final String? isNotVerifiedPass = prefs.getString("temp_login_password");

    if (isNotVerified != null) {
      navigateToPage(context, "verify-email",
          data: VerifyEmail(
              emailId: isNotVerified, password: isNotVerifiedPass ?? ""));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userLoginProvider);
    final size = MediaQuery.of(context).size;
    final translation = AppLocalizations.of(context)!;

    return UpgradeAlert(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            bottom: true,
            top: false,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(50)),
                    child: Container(
                      width: size.width,
                      height: (user is LoadedUserLoginResponseState &&
                              !user.userLoginResponse.isLoggedIn!)
                          ? (size.height > 840
                              ? size.height / 1.85
                              : size.height / 2.16)
                          : (size.height > 840
                              ? size.height / 1.85
                              : size.height / 1.6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF986E),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          CatchMFlixxImages.ticket,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  fillOverscroll: true,
                  hasScrollBody: false,
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(50)),
                    child: Container(
                        width: size.width,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(71, 8, 17, 36)),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: (user is LoadedUserLoginResponseState &&
                                  !user.userLoginResponse.isLoggedIn!)
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      translation.login,
                                      style: TextStyles.headingMobile,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      'Welcome to CatchMflix, login or register to continue',
                                      style: TextStyles.smallSubText,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Animate(
                                      effects: const [
                                        FadeEffect(
                                            delay: Duration(milliseconds: 100))
                                      ],
                                      child: OffsetFullButton(
                                          content: translation.login,
                                          icon: Icons.account_circle,
                                          fn: () => navigateToPage(
                                              context, "/onboard/1")),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Animate(
                                      effects: const [
                                        FadeEffect(
                                            delay: Duration(milliseconds: 200))
                                      ],
                                      child: OffsetFullButton(
                                        content: translation.register,
                                        icon: PhosphorIconsBold.book,
                                        fn: () => navigateToPage(
                                            context, "/onboard/0"),
                                      ),
                                    ),
                                    // const SizedBox(
                                    //   height: 10,
                                    // ),
                                    // Animate(
                                    //   effects: const [
                                    //     FadeEffect(
                                    //         delay: Duration(milliseconds: 300))
                                    //   ],
                                    //   child: OffsetSecondaryFullButton(
                                    //       icon: const Icon(
                                    //         PhosphorIconsBold.rocketLaunch,
                                    //       ),
                                    //       content: translation.tryA,
                                    //       fn: () {
                                    //         navigateToPage(
                                    //             context, const BaseMain(),
                                    //             removeUntil: true,
                                    //             predicate: (r) => false);
                                    //       }),
                                    // ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    // Animate(
                                    //   effects: const [
                                    //     FadeEffect(
                                    //         delay: Duration(milliseconds: 400))
                                    //   ],
                                    //   child: OffsetSecondaryFullButton(
                                    //       content: translation.changeLanguage,
                                    //       icon: const Icon(
                                    //           PhosphorIconsBold.translate),
                                    //       fn: () {
                                    //         navigateToPage(context, "/languages");
                                    //       }),
                                    // )
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Animate(
                                      effects: const [FadeEffect()],
                                      child: Text(
                                        translation.welcomeBack,
                                        style: TextStyles.headingMobile,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Animate(
                                      effects: const [
                                        FadeEffect(
                                            delay: Duration(milliseconds: 300))
                                      ],
                                      child: Text(
                                        translation.selectProfileNext,
                                        style: TextStyles.smallSubText,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Animate(
                                      effects: const [
                                        FadeEffect(
                                            delay: Duration(milliseconds: 600))
                                      ],
                                      child: OffsetFullButton(
                                        content: translation.continueTo,
                                        icon: Icons.view_stream,
                                        fn: () async {
                                          ProfileApi pro = ProfileApi();
                                          final res = await pro.fetchProfiles();
                                          navigateToPage(context,
                                              "/user/profile-selection",
                                              data: res, isReplacement: true);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                        )),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
