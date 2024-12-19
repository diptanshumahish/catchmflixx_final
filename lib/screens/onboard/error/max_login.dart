import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/models/user/maxlimit.response.model.dart';

import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/utils/datetime/format_date.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';

class MaxLogin extends ConsumerStatefulWidget {
  final MaxLimit limit;
  const MaxLogin({super.key, required this.limit});

  @override
  ConsumerState<MaxLogin> createState() => _MaxLoginState();
}

class _MaxLoginState extends ConsumerState<MaxLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            //   decoration: BoxDecoration(
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.5),
            //         blurRadius: 8,
            //         spreadRadius: 1,
            //       ),
            //     ],
            //   ),
            //   child: Row(
            //     children: [
            //       IconButton(
            //         onPressed: () {
            //           navigateToPage(context, "/onboard", isReplacement: true);
            //         },
            //         icon: const Icon(
            //           Icons.chevron_left,
            //           color: Colors.white,
            //         ),
            //       ),
            //       const Expanded(
            //         child: Text(
            //           "Maximum Login Limit Reached",
            //           style: TextStyles.headingMobile,
            //           textAlign: TextAlign.center,
            //         ),
            //       ),
            //       const SizedBox(width: 48), // to balance the leading icon
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: GestureDetector(
                        onTap: () {
                          navigateToPage(context, "/", isReplacement: true);
                        },
                        child: const Row(
                          children: [
                            PhosphorIcon(
                              PhosphorIconsBold.arrowLeft,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              "back",
                              style: TextStyles
                                  .headingsForSectionsForSmallerScreens,
                            )
                          ],
                        ),
                      ),
                    ),
                    Text(
                      "Action needed",
                      style: TextStyles.headingMobile
                          .copyWith(fontSize: 42, color: Colors.blue[100]),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "You have logged in at more devices than in your plan",
                      style: TextStyles.headingsForSections,
                    )
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "You have reached the maximum login limit of 3 sessions for your current plan. Please log out from one of the sessions below to proceed.",
                style: TextStyles.formSubTitle,
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: widget.limit.data!.sessions!.length,
                itemBuilder: (context, index) {
                  final session = widget.limit.data!.sessions![index];
                  return GestureDetector(
                    onTap: () async {
                      int res = await ref
                          .read(userLoginProvider.notifier)
                          .makeManualLogin(
                              session.id.toString(), context, false);

                      if (res == 200) {
                        navigateToPage(context, "/check-login",
                            isReplacement: true);
                      } else if (res == 500) {
                        navigateToPage(context, "/base", isReplacement: true);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[700]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                session.userAgent=="Other Other"?"login ${index+1}":session.userAgent??"",
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
                          const PhosphorIcon(
                            PhosphorIconsRegular.x,
                            color: Colors.redAccent,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
