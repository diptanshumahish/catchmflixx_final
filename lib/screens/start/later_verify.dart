import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/screens/start/check_logged_in.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/widgets/common/buttons/full_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool _initial = true;

class LaterVerifyScreen extends ConsumerStatefulWidget {
  const LaterVerifyScreen({
    super.key,
  });

  @override
  ConsumerState<LaterVerifyScreen> createState() => _LaterVerifyScreenState();
}

class _LaterVerifyScreenState extends ConsumerState<LaterVerifyScreen> {
  @override
  void initState() {
    tryLogin();
    super.initState();
  }

  Future<void> tryLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String temp_login_mail = prefs.getString("temp_login_mail")!;
    final String temp_login_password = prefs.getString("temp_login_password")!;

    int res = await ref
        .read(userLoginProvider.notifier)
        .makeLogin(temp_login_mail, temp_login_password, context, false);

    if (res == 200) {
      await prefs.remove("temp_login_mail");
      await prefs.remove("temp_login_password");
      Navigator.of(context).pushAndRemoveUntil(
          PageTransition(
            child: const CheckLoggedIn(),
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInCubic,
          ),
          (r) => false);
    } else {
      setState(() {
        _initial = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black54,
      body: GestureDetector(
        child: SizedBox(
          height: size.height,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.white38),
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          const Text(
                            "Verifying Your mail",
                            style: TextStyles.headingsForSections,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          _initial == true
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Icon(
                                  Icons.error_outline,
                                  color: Colors.white,
                                ),
                          _initial == false
                              ? const Text(
                                  "You have not verified your email yet, please check your inbox and spam for your verification mail",
                                  style: TextStyles.detailsMobile,
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(
                            height: 10,
                          ),
                          _initial == false
                              ? FullButton(
                                  content: "Continue",
                                  fn: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _initial = true;
                                    });
                                  })
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
