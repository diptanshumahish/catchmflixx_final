import 'dart:math';

import 'package:catchmflixx/api/content/common.dart';
import 'package:catchmflixx/constants/images.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/models/content/search.list.model.dart';
import 'package:catchmflixx/screens/main/movie_screens/movie_screen.dart';
import 'package:catchmflixx/screens/main/series/series_screen.dart';
import 'package:catchmflixx/screens/payments/payment_plans_screen.dart';
import 'package:catchmflixx/widgets/common/buttons/full_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';

bool _isReady = false;
ContentList _cList = ContentList();

class TopBarBanner extends StatefulWidget {
  const TopBarBanner({
    super.key,
  });

  @override
  State<TopBarBanner> createState() => _TopBarBannerState();
}

class _TopBarBannerState extends State<TopBarBanner> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    ContentManager ct = ContentManager();
    ContentList data = await ct.searchContent("");
    if (data.results!.success!) {
      setState(() {
        _cList = data;
        _isReady = true;
      });
    }
  }

  int randomNo(int maxLength) {
    Random random = Random();
    return random.nextInt(maxLength);
  }

  @override
  Widget build(BuildContext context) {
    final rand = randomNo(_cList.results?.data?.length ?? 1);
    final size = MediaQuery.of(context).size;
    // final translation = AppLocalizations.of(context)!;

    if (_isReady) {
      return FlexibleSpaceBar(
          background: Stack(
        children: [
          Animate(
            effects: const [FadeEffect()],
            child: Image.network(
              _cList.results?.data![rand].thumbnail ??
                  "https://img.playbook.com/Axh_gEkgZbsvB1VDuXm4GNvbjXXu2RUUqwToXJEJ8ZQ/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzM5NTk3ODYx/LWQ1MzItNDZmMC1i/ZDhmLTQ2NjRiYjcz/NjZmMQ",
              height: 600,
              fit: BoxFit.cover,
              width: size.width,
            ),
          ),
          Positioned(
              top: size.height / 30,
              left: size.height / 40,
              child: SvgPicture.asset(
                CatchMFlixxImages.textLogo,
                height: 30,
              )),
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Colors.transparent,
                  Colors.black54,
                  Colors.black
                ])),
          ),
          Padding(
            padding: EdgeInsets.all(size.height / 40),
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Animate(
                    effects: const [
                      FadeEffect(delay: Duration(milliseconds: 200))
                    ],
                    child: Text(
                      _cList.results?.data![rand].metaData?.title ?? "",
                      style: size.height > 840
                          ? TextStyles.headingMobile
                          : TextStyles.headingMobileSmallScreens,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Animate(
                    effects: const [
                      FadeEffect(delay: Duration(milliseconds: 300))
                    ],
                    child: Text(
                      _cList.results?.data![rand].metaData?.description ?? "",
                      style: TextStyles.smallSubText,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Animate(
                    effects: const [
                      FadeEffect(delay: Duration(milliseconds: 400))
                    ],
                    child: FullButton(
                        content: "Know more",
                        fn: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              child: _cList.results?.data![rand].type == "movie"
                                  ? MovieScreen(
                                      uuid: _cList.results?.data![rand].uuid ??
                                          "",
                                    )
                                  : SeriesScreen(
                                      uuid: _cList.results?.data![rand].uuid ??
                                          "",
                                    ),
                              type: PageTransitionType.leftToRight,
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              top: size.height / 29,
              right: size.height / 40,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: const PaymentsPlansScreen(),
                      type: PageTransitionType.leftToRight,
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white38),
                      borderRadius: BorderRadius.circular(9)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Subscribe",
                          style: TextStyles.cardHeading,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.spa,
                          color: Colors.white,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ));
    } else {
      return FlexibleSpaceBar(
        background: SizedBox(
          height: 600,
          width: size.width,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.transparent,
                  highlightColor: Colors.white,
                  child: SvgPicture.asset(
                    CatchMFlixxImages.textLogo,
                    height: 30,
                  ),
                ),
                const CupertinoActivityIndicator(
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
