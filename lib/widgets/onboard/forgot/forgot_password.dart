import 'package:catchmflixx/api/user/reset/reset.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_full_button.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_secondary_button.dart';
import 'package:catchmflixx/widgets/common/inputs/input_field.dart';
import 'package:flutter/material.dart';

final _emailController = TextEditingController();

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          bottom: true,
          top: true,
          child: ListView(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Enter your email to proceed",
                      style: TextStyles.headingMobile,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Enter your existing email address",
                      style: TextStyles.detailsMobile,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CatchMFLixxInputField(
                        labelText: "Enter your email",
                        icon: Icons.email,
                        controller: _emailController,
                        validator: (value) {
                          RegExp emReg =
                              RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
                          final match = emReg.hasMatch(value ?? '');
                          if (!match) {
                            return "invalid email";
                          } else {
                            return null;
                          }
                        },
                        type: TextInputType.emailAddress),
                    const SizedBox(
                      height: 20,
                    ),
                    OffsetFullButton(
                        content: "Send reset link",
                        fn: () async {
                          if (_emailController.text.isEmpty) {
                            ToastShow.returnToast("No email");
                            return;
                          }
                          ResetPassword rs = ResetPassword();
                          final res =
                              await rs.addResetSent(_emailController.text);
                          if (res.success!) {
                            ToastShow.returnToast(res.data!.message!);
                            navigateToPage(context, "/check-login");
                          }
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    OffsetSecondaryFullButton(
                        content: "Back",
                        fn: () {
                          Navigator.of(context).pop();
                        })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
