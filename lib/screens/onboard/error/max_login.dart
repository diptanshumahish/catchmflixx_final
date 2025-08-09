import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/models/user/maxlimit.response.model.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/state/user/login/user.login.response.state.dart';
import 'package:catchmflixx/utils/datetime/format_date.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MaxLogin extends ConsumerStatefulWidget {
  final MaxLimit limit;
  const MaxLogin({super.key, required this.limit});

  @override
  ConsumerState<MaxLogin> createState() => _MaxLoginState();
}

class _MaxLoginState extends ConsumerState<MaxLogin> {
  int? _selectedSessionId;

  IconData _iconForUserAgent(String? userAgent) {
    final ua = (userAgent ?? '').toLowerCase();
    if (ua.contains('iphone') || ua.contains('ios'))
      return PhosphorIconsBold.deviceMobile;
    if (ua.contains('android')) return PhosphorIconsBold.deviceMobile;
    if (ua.contains('mac') || ua.contains('darwin'))
      return PhosphorIconsBold.laptop;
    if (ua.contains('windows') || ua.contains('win'))
      return PhosphorIconsBold.monitor;
    if (ua.contains('linux')) return PhosphorIconsBold.monitor;
    return PhosphorIconsBold.deviceMobile;
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(userLoginProvider);
    final isProcessing = loginState is LoadingUserLoginResponseState;
    final sessions = widget.limit.data?.sessions ?? [];
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: GestureDetector(
                    onTap: isProcessing
                        ? null
                        : () {
                            navigateToPage(context, "/", isReplacement: true);
                          },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const PhosphorIcon(
                          PhosphorIconsBold.arrowLeft,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "back",
                          style:
                              TextStyles.headingsForSectionsForSmallerScreens,
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PhosphorIcon(
                        PhosphorIconsBold.warningCircle,
                        color: Colors.amber,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Max devices reached",
                              style: TextStyles.headingMobile.copyWith(
                                  fontSize: 36, color: Colors.blue[100]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "You're signed in on too many devices. Sign out from one of the sessions below to continue here.",
                              style: TextStyles.formSubTitle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (sessions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Text(
                      "Active sessions (${sessions.length})",
                      style: TextStyles.headingsForSections,
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      final isThisItemProcessing =
                          isProcessing && _selectedSessionId == session.id;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[800]!),
                        ),
                        child: Row(
                          children: [
                            PhosphorIcon(
                              _iconForUserAgent(session.userAgent),
                              color: Colors.white,
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (session.userAgent == "Other Other" ||
                                            (session.userAgent ?? '').isEmpty)
                                        ? "login ${index + 1}"
                                        : (session.userAgent ?? ''),
                                    style: TextStyles.cardHeading,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formatDate(session.lastLogin ?? ""),
                                    style: TextStyles.formSubTitle.copyWith(
                                      color: Colors.white54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              height: 36,
                              child: ElevatedButton.icon(
                                onPressed: (isProcessing)
                                    ? null
                                    : () async {
                                        setState(() {
                                          _selectedSessionId = session.id;
                                        });
                                        final res = await ref
                                            .read(userLoginProvider.notifier)
                                            .makeManualLogin(
                                                session.id.toString(),
                                                context,
                                                false);
                                        if (!mounted) return;
                                        if (res == 200) {
                                          navigateToPage(
                                              context, "/check-login",
                                              isReplacement: true);
                                        } else if (res == 500) {
                                          navigateToPage(context, "/base",
                                              isReplacement: true);
                                        }
                                        setState(() {
                                          _selectedSessionId = null;
                                        });
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 179, 0, 0),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                icon: isThisItemProcessing
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(PhosphorIconsBold.x),
                                label: Text(
                                  isThisItemProcessing
                                      ? "Signing out..."
                                      : "Sign out",
                                  style: TextStyles.formSubTitle,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                  child: Text(
                    "Tip: You'll continue here after signing out from another device.",
                    style:
                        TextStyles.formSubTitle.copyWith(color: Colors.white54),
                  ),
                ),
              ],
            ),
            if (isProcessing)
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: true,
                  child: Container(
                    color: Colors.black.withOpacity(0.25),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
