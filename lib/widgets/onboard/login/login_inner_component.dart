import 'package:catchmflixx/api/user/user_activity/user.activity.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_full_button.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_secondary_button.dart';
import 'package:catchmflixx/widgets/common/buttons/secondary_full_button.dart';
import 'package:catchmflixx/widgets/common/flex/flex_items.dart';
import 'package:catchmflixx/widgets/common/inputs/input_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

//controllers
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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Future<void> googleSignIn() async {
      await launchUrl(
          Uri.parse('https://catchmflixx.com/en/app-google-login-redirect'));
    }

    final size = MediaQuery.of(context).size;
    final translation = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.all(size.height / 40),
      child: SizedBox(
        child: Form(
          key: _formKey,
          child: FlexItems(widgetList: [
            const Text(
              "Login with your Google account",
              style: TextStyles.headingMobile,
            ),
            SecondaryFullButton(
              content: "Sign in with google",
              fn: () async {
                await googleSignIn();
              },
              icon: const PhosphorIcon(PhosphorIconsBold.googleLogo),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("OR",
                    textAlign: TextAlign.center,
                    style: TextStyles.headingsForSections
                        .copyWith(color: Colors.orangeAccent)),
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
                  final match = emReg.hasMatch(value ?? '');
                  if (!match) {
                    return translation.emVal;
                  } else {
                    return null;
                  }
                },
                type: TextInputType.emailAddress),
            CatchMFLixxInputField(
              labelText: translation.password,
              icon: Icons.lock,
              controller: _passwordController,
              type: TextInputType.text,
              validator: (data) {
                if (data!.isEmpty) {
                  return "Password cannot be empty";
                }
                return null;
              },
              obscureText: true,
            ),
            OffsetFullButton(
              content: translation.login,
              icon: Icons.login,
              fn: () async {
                bool valid = _formKey.currentState!.validate();

                if (valid) {
                  int res = await ref
                      .read(userLoginProvider.notifier)
                      .makeLogin(_eOrMController.text.toString(),
                          _passwordController.text.toString(), context, false);

                  if (res == 200) {
                    navigateToPage(context, "/check-login",
                        isReplacement: true);
                  } else if (res == 500) {
                    navigateToPage(
                      context,
                      "/base",
                      isReplacement: true,
                    );
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
            OffsetSecondaryFullButton(
                content: translation.changeLanguage,
                icon: const Icon(Icons.language),
                fn: () {
                  navigateToPage(context, "/languages");
                }),
            Text.rich(TextSpan(style: TextStyles.smallSubText, children: [
              const TextSpan(
                  text: "By Logging in to CatchMFlixx, you agree to our "),
              TextSpan(
                  text: "Terms & conditions ",
                  style: TextStyles.smallSubTextActive,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrl(
                          Uri.parse("https://www.catchmflixx.com/en/terms"));
                    }),
              const TextSpan(text: "& "),
              TextSpan(
                  text: "Privacy Policies",
                  style: TextStyles.smallSubTextActive,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrl(Uri.parse(
                          "https://www.catchmflixx.com/en/privacy-policy"));
                    })
            ]))
          ], space: 20),
        ),
      ),
    );
  }
}
