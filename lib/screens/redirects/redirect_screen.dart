import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RedirectScreen extends ConsumerStatefulWidget {
  const RedirectScreen({super.key, required this.code});

  final String code;

  @override
  RedirectScreenState createState() => RedirectScreenState();
}

class RedirectScreenState extends ConsumerState<RedirectScreen> {
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    Future(() => doRedirect());
  }

  Future<void> doRedirect() async {
    if (mounted) {
      try {
        final res = await ref
            .read(userLoginProvider.notifier)
            .makeGoogleLogin(widget.code, context, false);
        if (res == 200) {
          navigateToPage(context, "/check-login", isReplacement: true);
        } else {
          setState(() {
            _hasError = true;
          });
        }
      } catch (e) {
        setState(() {
          _hasError = true;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _hasError
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'An error occurred. Please try again.',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          navigateToPage(context, "/");
                        },
                        child: const Text('Go to Home'),
                      ),
                    ],
                  )
                : Container(),
      ),
    );
  }
}
