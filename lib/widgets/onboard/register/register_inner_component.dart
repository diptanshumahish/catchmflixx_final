import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/screens/language/language_screen.dart';
import 'package:catchmflixx/screens/start/verify_email.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/utils/password/password_strength.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_full_button.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_secondary_button.dart';
import 'package:catchmflixx/widgets/common/flex/flex_items.dart';
import 'package:catchmflixx/widgets/common/inputs/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

//controllers
final TextEditingController _emailController = TextEditingController();
final TextEditingController _phController = TextEditingController();
final TextEditingController _nameController = TextEditingController();
final TextEditingController _pinController = TextEditingController();
final TextEditingController _cityController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _password2Controller = TextEditingController();
final TextEditingController _dobController = TextEditingController();

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
            Text(
              translation.createNew,
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
              validator: (value) =>
                  value!.length < 6 ? translation.nameVal : null,
            ),
            CatchMFLixxInputField(
              labelText: translation.mob,
              icon: Icons.phone,
              controller: _phController,
              type: TextInputType.number,
              validator: (mob) {
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
                  _dobController.text = '${value.substring(0, value.length)}/';
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
                if (val!.length < 6 || val.length > 6) {
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
            OffsetFullButton(
              content: translation.register,
              fn: () async {
                bool valid = _formKey.currentState!.validate();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                if (valid) {
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
                    ToastShow.returnToast(translation.ver);
                    prefs.setString("temp_login_mail", _emailController.text);
                    prefs.setString(
                        "temp_login_password", _passwordController.text);

                    Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                          child: VerifyEmail(
                              emailId: _emailController.text,
                              password: _passwordController.text),
                          type: PageTransitionType.rightToLeft,
                        ),
                        (r) => false);
                  } else if (res == 400) {
                    ToastShow.returnToast(translation.err);
                  } else {
                    ToastShow.returnToast(translation.datamissing);
                  }
                } else {
                  ToastShow.returnToast(translation.chk);
                }
              },
            ),
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
                })
          ], space: 20),
        ),
      ),
    );
  }
}
