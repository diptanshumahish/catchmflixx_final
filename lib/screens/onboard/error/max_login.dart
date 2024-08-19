import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/models/user/maxlimit.response.model.dart';

import 'package:catchmflixx/state/provider.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.black,
              title: const Text(
                "Maximum Login limit reached",
                style: TextStyles.headingMobile,
              ),
              leading: IconButton(
                  onPressed: () {
                    navigateToPage(context, "/onboard", isReplacement: true);
                  },
                  icon: const Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                  )),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "You are already logged in at 3 different sessions, your current plan limits maximum of 3 sessions, kindly logout from any of the sessions below to proceeed.",
                      style: TextStyles.formSubTitle,
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.limit.data!.sessions!
                      .map((e) => GestureDetector(
                            onTap: () async {
                              int res = await ref
                                  .read(userLoginProvider.notifier)
                                  .makeManualLogin(
                                      e.id.toString(), context, false);

                              if (res == 200) {
                                navigateToPage(context, "/check-login",
                                    isReplacement: true);
                              } else if (res == 500) {
                                navigateToPage(context, "/base",
                                    isReplacement: true);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.white24)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e.userAgent ?? "",
                                            style: TextStyles.cardHeading,
                                          ),
                                          Text(
                                            formatDate(e.lastLogin ?? ""),
                                            style: TextStyles.formSubTitle,
                                          ),
                                        ],
                                      ),
                                      const PhosphorIcon(
                                        PhosphorIconsRegular.x,
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
