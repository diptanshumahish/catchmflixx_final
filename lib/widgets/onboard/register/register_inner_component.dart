import 'package:catchmflixx/api/user/user_activity/user.activity.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
// import 'package:catchmflixx/screens/start/verify_email.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/utils/go_router/go.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/password/password_strength.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_full_button.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_secondary_button.dart';
import 'package:catchmflixx/widgets/common/buttons/secondary_full_button.dart';
import 'package:catchmflixx/widgets/common/flex/flex_items.dart';
import 'package:catchmflixx/widgets/common/inputs/input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

//controllers
final TextEditingController _emailController = TextEditingController();
final TextEditingController _phController = TextEditingController();
final TextEditingController _nameController = TextEditingController();
final TextEditingController _pinController = TextEditingController();
final TextEditingController _cityController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _password2Controller = TextEditingController();
final TextEditingController _dobController = TextEditingController();
bool _loadingReg = false;

class RegisterInner extends ConsumerStatefulWidget {
  const RegisterInner({
    super.key,
  });

  @override
  ConsumerState<RegisterInner> createState() => _RegisterInnerState();
}

class _RegisterInnerState extends ConsumerState<RegisterInner> {
  int _currentLength = 0;
  final _formKey = GlobalKey<FormState>();
  bool _showEmailRegistration = false;

  Future<void> googleSignIn() async {
    await launchUrl(
        Uri.parse('https://catchmflixx.com/en/app-google-login-redirect'));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final reg = ref.read(userRegisterProvider.notifier);
    final translation = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.all(size.height / 40),
      child: SizedBox(
        child: Form(
          key: _formKey,
          child: FlexItems(widgetList: [
            const Text(
              "Use Google to seamlessly sign up to CatchMFLixx",
              style: TextStyles.headingMobile,
            ),
            const Text(
              "register with a single click!",
              style: TextStyles.detailsMobile,
            ),
            SecondaryFullButton(
              content: "Sign up with google",
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
            OffsetSecondaryFullButton(
              content: _showEmailRegistration
                  ? "Hide email registration"
                  : "Register with email and details",
              icon: const Icon(Icons.email),
              fn: () {
                setState(() {
                  _showEmailRegistration = !_showEmailRegistration;
                });
              },
            ),
            if (_showEmailRegistration) ...[
              const Text(
                "Use your email and other details to create an account with CatchMFLixx",
                style: TextStyles.headingMobile,
              ),
              Text(
                translation.registerDetails,
                style: TextStyles.detailsMobile,
              ),
              CatchMFLixxInputField(
                  labelText: translation.fullName,
                  icon: Icons.person,
                  controller: _nameController,
                  type: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a name";
                    }
                    if (value.length < 6) {
                      return translation.nameVal;
                    }
                    return null;
                  }),
              CatchMFLixxInputField(
                labelText: translation.mob,
                icon: Icons.phone,
                controller: _phController,
                type: TextInputType.number,
                validator: (mob) {
                  if (mob!.isEmpty) {
                    return "Please enter mobile number";
                  }
                  final RegExp regExp = RegExp(r'^[6-9]\d{9}$');
                  if (regExp.hasMatch(mob!) == false) {
                    return translation.mobVal;
                  }
                  return null;
                },
              ),
              CatchMFLixxInputField(
                labelText: translation.em,
                icon: Icons.alternate_email,
                controller: _emailController,
                type: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter an email address";
                  }
                  RegExp emReg =
                      RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
                  final match = emReg.hasMatch(value ?? '');
                  if (!match) {
                    return translation.emVal;
                  } else {
                    return null;
                  }
                },
              ),
              CatchMFLixxInputField(
                labelText: translation.enterDOB,
                onchange: (value) {
                  if (value!.length == 8) {
                    return null;
                  }
                  if (value.length > _currentLength && value.length % 3 == 2) {
                    _dobController.text =
                        '${value.substring(0, value.length)}/';
                    _currentLength = value.length;
                  } else {
                    _currentLength = value.length;
                  }

                  if (value.length > 10) {
                    _dobController.text = value.substring(0, 10);
                  }

                  return null;
                },
                icon: Icons.calendar_month,
                controller: _dobController,
                type: TextInputType.datetime,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^[0-9]{0,2}/?[0-9]{0,2}/?[0-9]{0,4}'))
                ],
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Please enter your date of birth";
                  }
                  RegExp emReg = RegExp(
                      r'^(0?[1-9]|[12][0-9]|3[01])/(0?[1-9]|1[0-2])/\d{4}$');
                  final match = emReg.hasMatch(val ?? '');

                  if (!match) {
                    return translation.dobValidate;
                  } else {
                    return null;
                  }
                },
              ),
              CatchMFLixxInputField(
                  labelText: translation.city,
                  icon: Icons.area_chart,
                  controller: _cityController,
                  type: TextInputType.text),
              CatchMFLixxInputField(
                labelText: translation.pin,
                icon: Icons.area_chart,
                controller: _pinController,
                type: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Please enter area pin code";
                  }
                  if (val.length < 6 || val.length > 6) {
                    return translation.pinVal;
                  }
                  return null;
                },
              ),
              CatchMFLixxInputField(
                labelText: translation.pass,
                icon: Icons.lock,
                controller: _passwordController,
                type: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please create a password to continue";
                  }
                  PasswordStrength strength = getPasswordStrength(value!);
                  if (strength == PasswordStrength.weak) {
                    return translation.passVal;
                  }
                  return null;
                },
                obscureText: true,
              ),
              CatchMFLixxInputField(
                labelText: translation.rePass,
                icon: Icons.lock,
                controller: _password2Controller,
                type: TextInputType.text,
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return translation.passNoMatch;
                  }
                  return null;
                },
              ),
              if (_loadingReg)
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.white,
                    )
                  ],
                ),
              if (!_loadingReg)
                OffsetFullButton(
                  content: translation.register,
                  fn: () async {
                    bool valid = _formKey.currentState!.validate();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    if (valid) {
                      setState(() {
                        _loadingReg = true;
                      });
                      int res = await reg.makeRegister(
                          _emailController.text,
                          _phController.text,
                          _nameController.text,
                          int.parse(_pinController.text),
                          _cityController.text,
                          _passwordController.text,
                          _password2Controller.text,
                          _dobController.text);
                      if (res == 200) {
                        setState(() {
                          _loadingReg = false;
                        });
                        int res = await ref
                            .read(userLoginProvider.notifier)
                            .makeLogin(
                                _emailController.text.toString(),
                                _passwordController.text.toString(),
                                context,
                                false);

                        if (res == 200) {
                          navigateToPage(context, "/check-login",
                              isReplacement: true);
                        }
                        ToastShow.returnToast(translation.ver);
                        // prefs.setString("temp_login_mail", _emailController.text);
                        // prefs.setString(
                        //     "temp_login_password", _passwordController.text);
                        // navigateToPage(context, "/verify/email",
                        //     data: VerifyEmail(
                        //         emailId: _emailController.text,
                        //         password: _passwordController.text),
                        //     isReplacement: true);
                      } else if (res == 400) {
                        setState(() {
                          _loadingReg = false;
                        });
                        ToastShow.returnToast(translation.err);
                      } else {
                        setState(() {
                          _loadingReg = false;
                        });
                        ToastShow.returnToast(translation.datamissing);
                      }
                    } else {
                      setState(() {
                        _loadingReg = false;
                      });
                      ToastShow.returnToast(translation.chk);
                    }
                  },
                ),
              OffsetSecondaryFullButton(
                  content: translation.changeLanguage,
                  icon: const Icon(Icons.language),
                  fn: () {
                    navigateToPage(context, "/languages");
                  })
            ]
          ], space: 20),
        ),
      ),
    );
  }
}
