import 'dart:io';

import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/password/password_strength.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_full_button.dart';
import 'package:catchmflixx/widgets/common/buttons/google_full_button.dart';
import 'package:catchmflixx/widgets/common/flex/flex_items.dart';
import 'package:catchmflixx/widgets/common/inputs/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

final TextEditingController _emailController = TextEditingController();
final TextEditingController _phController = TextEditingController();
final TextEditingController _nameController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _password2Controller = TextEditingController();
bool _loadingReg = false;
bool _showPassword = false;
bool _showConfirmPassword = false;

class RegisterInner extends ConsumerStatefulWidget {
  const RegisterInner({super.key});

  @override
  ConsumerState<RegisterInner> createState() => _RegisterInnerState();
}

class _RegisterInnerState extends ConsumerState<RegisterInner> {
  final _formKey = GlobalKey<FormState>();
  final GoogleSignIn googleSignInInApp = GoogleSignIn();

  Future<void> googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignInInApp.signIn();
      if (googleUser == null) return;
      final googleAuth = await googleUser.authentication;
      navigateToPage(
        context,
        '/en/sign-in-app/success?idToken=${googleAuth.idToken}&accessToken=${googleAuth.accessToken}',
      );
    } catch (error) {
      ToastShow.returnToast('$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final reg = ref.read(userRegisterProvider.notifier);
    final translation = AppLocalizations.of(context)!;

    if (Platform.isAndroid) {
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
            key: _formKey,
            child: FlexItems(
              space: 20,
              widgetList: [
                if (Platform.isAndroid) ...[
                  const Text("Create your account",
                      style: TextStyles.headingMobile),
                  Text("Join CatchMFLixx in seconds",
                      style: TextStyles.detailsMobile),
                  GoogleFullButton(
                    content: "Sign up with Google",
                    fn: () async => await googleSignIn(),
                  ),
                  Row(children: [
                    Expanded(
                        child: Divider(color: Colors.white.withOpacity(0.12))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("OR", style: TextStyles.detailsMobile),
                    ),
                    Expanded(
                        child: Divider(color: Colors.white.withOpacity(0.12))),
                  ]),
                ],

                const Text("Sign up with email", style: TextStyles.headingMobile),
                Text(translation.registerDetails,
                    style: TextStyles.detailsMobile),

                // Name Field
                CatchMFLixxInputField(
                  labelText: translation.fullName,
                  icon: Icons.person,
                  controller: _nameController,
                  type: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) return "Please enter a name";
                    if (value.length < 6) return translation.nameVal;
                    return null;
                  },
                ),

                // Email Field
                CatchMFLixxInputField(
                  labelText: translation.em,
                  icon: Icons.alternate_email,
                  controller: _emailController,
                  type: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) return "Please enter an email address";
                    RegExp emReg =
                        RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
                    return emReg.hasMatch(value) ? null : translation.emVal;
                  },
                ),
                // Password
                CatchMFLixxInputField(
                  labelText: translation.pass,
                  icon: Icons.lock,
                  controller: _passwordController,
                  type: TextInputType.text,
                  obscureText: !_showPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                        _showPassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white70),
                    onPressed: () => setState(() => _showPassword = !_showPassword),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please create a password to continue";
                    }
                    return getPasswordStrength(value) == PasswordStrength.weak
                        ? translation.passVal
                        : null;
                  },
                ),

                // Confirm Password
                CatchMFLixxInputField(
                  labelText: translation.rePass,
                  icon: Icons.lock_outline,
                  controller: _password2Controller,
                  type: TextInputType.text,
                  obscureText: !_showConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                        _showConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white70),
                    onPressed: () => setState(
                        () => _showConfirmPassword = !_showConfirmPassword),
                  ),
                  validator: (value) {
                    return value != _passwordController.text
                        ? translation.passNoMatch
                        : null;
                  },
                ),

                OffsetFullButton(
                  content: translation.register,
                  isLoading: _loadingReg,
                  fn: () async {
                    final valid = _formKey.currentState!.validate();
                    if (!valid) {
                      ToastShow.returnToast(translation.chk);
                      return;
                    }

                    setState(() => _loadingReg = true);

                    final res = await reg.makeRegister(
                      _emailController.text,
                      Platform.isAndroid ? _phController.text : '',
                      _nameController.text,
                      _passwordController.text,
                      _password2Controller.text,
                    );

                    setState(() => _loadingReg = false);

                    if (res == 200) {
                      final loginRes = await ref
                          .read(userLoginProvider.notifier)
                          .makeLogin(_emailController.text,
                              _passwordController.text, context, false);
                      if (loginRes == 200) {
                        navigateToPage(context, "/check-login",
                            isReplacement: true);
                      }
                      ToastShow.returnToast(translation.ver);
                    } else {
                      ToastShow.returnToast(res == 400
                          ? translation.err
                          : translation.datamissing);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      );
    } else {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.info_outline, color: Colors.white70, size: 36),
                const SizedBox(height: 12),
                const Text(
                  "Create Your Account",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Registration on desktop is currently unavailable. Please use our website to create your account.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    launchUrl(Uri.parse("https://catchmflixx.com"));
                  },
                  child: const Text(
                    "https://catchmflixx.com",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
