// import 'package:catchmflixx/api/user/user_activity/user.activity.dart';
import 'dart:io' show Platform;

import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_full_button.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_secondary_button.dart';
import 'package:catchmflixx/widgets/common/flex/flex_items.dart';
import 'package:catchmflixx/widgets/common/inputs/input_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:catchmflixx/widgets/common/buttons/google_full_button.dart';

final TextEditingController _eOrMController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

class LoginInner extends ConsumerStatefulWidget {
  const LoginInner({
    super.key,
  });

  @override
  ConsumerState<LoginInner> createState() => _LoginInnerState();
}

class _LoginInnerState extends ConsumerState<LoginInner> {
  final formKey = GlobalKey<FormState>();
  bool _showPassword = false;

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignInInApp = GoogleSignIn(
        clientId: Platform.isIOS
            ? '286624835671-asae5b6ett5tjpmbre56vgigng8iseag.apps.googleusercontent.com'
            : null,
        scopes: ['email', 'profile'],
      );

      final GoogleSignInAccount? googleUser = await googleSignInInApp.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      if (mounted) {
        navigateToPage(context,
            '/en/sign-in-app/success?idToken=$idToken&accessToken=$accessToken');
      }
    } catch (error) {
      ToastShow.returnToast('$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final translation = AppLocalizations.of(context)!;
    final UrlLauncherPlatform launcher = UrlLauncherPlatform.instance;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            size.height / 40,
            20,
            size.height / 40,
          ),
          child: Form(
            key: formKey,
            child: FlexItems(widgetList: [
             const  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome",
                    style: TextStyles.headingMobile,
                  ),
                   Text(
                    "Sign in to continue",
                    style: TextStyles.detailsMobile,
                  ),
                ],
              ),
              GoogleFullButton(
                content: "Sign in with Google",
                fn: () async => await signInWithGoogle(),
              ),
              Row(
                children: [
                  Expanded(
                      child: Divider(color: Colors.white.withOpacity(0.12))),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("OR", style: TextStyles.detailsMobile),
                  ),
                  Expanded(
                      child: Divider(color: Colors.white.withOpacity(0.12))),
                ],
              ),
              const Text(
                "Login with Email",
                style: TextStyles.headingMobile,
              ),
              Text(
                translation.loginDetails,
                style: TextStyles.detailsMobile,
              ),
              CatchMFLixxInputField(
                  labelText: "email",
                  icon: Icons.verified_user,
                  controller: _eOrMController,
                  validator: (value) {
                    RegExp emReg =
                        RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
                    if (!emReg.hasMatch((value ?? '').trim())) {
                      return translation.emVal;
                    }
                    return null;
                  },
                  type: TextInputType.emailAddress),
              CatchMFLixxInputField(
                labelText: translation.password,
                icon: Icons.lock,
                controller: _passwordController,
                type: TextInputType.text,
                obscureText: !_showPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _showPassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white70,
                  ),
                  onPressed: () => setState(() => _showPassword = !_showPassword),
                ),
                validator: (data) {
                  if (data!.isEmpty) return "Password cannot be empty";
                  return null;
                },
              ),
              OffsetFullButton(
                content: translation.login,
                icon: Icons.login,
                fn: () async {
                  bool valid = formKey.currentState!.validate();
                  if (valid) {
                    int res = await ref
                        .read(userLoginProvider.notifier)
                        .makeLogin(_eOrMController.text.trim(),
                            _passwordController.text.trim(), context, false);

                    if (res == 200) {
                      navigateToPage(context, "/check-login",
                          isReplacement: true);
                    } else if (res == 500) {
                      navigateToPage(context, "/base", isReplacement: true);
                    }
                  } else {
                    ToastShow.returnToast("Please check all fields");
                  }
                },
              ),
              OffsetSecondaryFullButton(
                  content: translation.forgotPassword,
                  icon: const Icon(Icons.question_mark),
                  fn: () {
                    navigateToPage(context, "/forgot-password");
                  }),
              Text.rich(TextSpan(style: TextStyles.smallSubText, children: [
                const TextSpan(
                    text: "By Logging in to CatchMFlixx, you agree to our "),
                TextSpan(
                    text: "Terms & conditions ",
                    style: TextStyles.smallSubTextActive,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        if (Platform.isIOS) {
                          launcher.launch(
                              "https://www.catchmflixx.com/en/terms",
                              useSafariVC: true,
                              enableDomStorage: false,
                              enableJavaScript: true,
                              useWebView: true,
                              headers: {},
                              universalLinksOnly: false);
                        } else {
                          await launchUrl(
                              Uri.parse("https://www.catchmflixx.com/en/terms"),
                              mode: LaunchMode.inAppWebView);
                        }
                      }),
                const TextSpan(text: "& "),
                TextSpan(
                    text: "Privacy Policies",
                    style: TextStyles.smallSubTextActive,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        if (Platform.isIOS) {
                          launcher.launch(
                              "https://catchmflixx.com/en/privacy-policy",
                              useSafariVC: true,
                              enableDomStorage: false,
                              enableJavaScript: true,
                              useWebView: true,
                              headers: {},
                              universalLinksOnly: false);
                        } else {
                          launchUrl(Uri.parse(
                              "https://www.catchmflixx.com/en/privacy-policy"));
                        }
                      })
              ])),
            ], space: 14),
          ),
        ),
      ),
    );
  }
}
