import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/screens/language/language_screen.dart';
import 'package:catchmflixx/screens/main/home_main.dart';
import 'package:catchmflixx/screens/start/check_logged_in.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_full_button.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_secondary_button.dart';
import 'package:catchmflixx/widgets/common/flex/flex_items.dart';
import 'package:catchmflixx/widgets/common/inputs/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:page_transition/page_transition.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final size = MediaQuery.of(context).size;
    final translation = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.all(size.height / 40),
      child: SizedBox(
        child: Form(
          key: _formKey,
          child: FlexItems(widgetList: [
            Text(
              translation.login,
              style: TextStyles.headingMobile,
            ),
            Text(
              translation.loginDetails,
              style: TextStyles.detailsMobile,
            ),
            CatchMFLixxInputField(
                labelText: translation.logEmMb,
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
                    Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                          child: const CheckLoggedIn(),
                          type: PageTransitionType.rightToLeft,
                        ),
                        (r) => false);
                  } else if (res == 500) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                          child: const BaseMain(),
                          type: PageTransitionType.rightToLeft,
                        ),
                        (r) => false);
                  }
                } else {
                  ToastShow.returnToast("Please check all fields");
                }
              },
            ),
            OffsetSecondaryFullButton(
                content: translation.forgotPassword,
                icon: const Icon(Icons.question_mark),
                fn: () {}),
            OffsetSecondaryFullButton(
                content: translation.changeLanguage,
                icon: const Icon(Icons.language),
                fn: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        child: const LanguageScreen(),
                        type: PageTransitionType.rightToLeft,
                        isIos: true),
                  );
                }),
            const Text.rich(TextSpan(style: TextStyles.smallSubText, children: [
              TextSpan(text: "By Logging in to CatchMFlixx, you agree to our "),
              TextSpan(
                  text: "Terms & conditions ",
                  style: TextStyles.smallSubTextActive),
              TextSpan(text: "& "),
              TextSpan(
                  text: "Privacy Policies",
                  style: TextStyles.smallSubTextActive)
            ]))
          ], space: 20),
        ),
      ),
    );
  }
}
