import 'dart:math';

import 'package:catchmflixx/api/content/common.dart';
import 'package:catchmflixx/constants/images.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/models/content/search.list.model.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_full_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer/shimmer.dart';

bool _isReady = false;
ContentList _cList = ContentList();

class TopBarBanner extends StatefulWidget {
  const TopBarBanner({super.key});

  @override
  State<TopBarBanner> createState() => _TopBarBannerState();
}

class _TopBarBannerState extends State<TopBarBanner> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    ContentManager ct = ContentManager();
    ContentList data = await ct.searchContent("");
    if (data.results?.success == true) {
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

    if (_isReady) {
      return FlexibleSpaceBar(
        background: Stack(
          children: [
            Animate(
              effects: const [FadeEffect()],
              child: Image.network(
                _cList.results?.data?[rand].thumbnail ??
                    "https://img.playbook.com/Axh_gEkgZbsvB1VDuXm4GNvbjXXu2RUUqwToXJEJ8ZQ/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzM5NTk3ODYx/LWQ1MzItNDZmMC1i/ZDhmLTQ2NjRiYjcz/NjZmMQ",
                height: 600,
                fit: BoxFit.cover,
                width: size.width,
              ),
            ),
            Positioned(
              top: size.height * 0.02,
              left: size.width * 0.04,
              child: SafeArea(
                child: SvgPicture.asset(
                  CatchMFlixxImages.textLogo,
                  height: 40,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black54,
                    Colors.black,
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(size.height * 0.03),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Animate(
                    effects: const [
                      FadeEffect(delay: Duration(milliseconds: 200))
                    ],
                    child: Text(
                      _cList.results?.data?[rand].metaData?.title ?? "",
                      style: TextStyles.headingMobile,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Animate(
                    effects: const [
                      FadeEffect(delay: Duration(milliseconds: 300))
                    ],
                    child: Text(
                      _cList.results?.data?[rand].metaData?.description ?? "",
                      style: TextStyles.smallSubText,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Animate(
                    effects: const [
                      FadeEffect(delay: Duration(milliseconds: 400))
                    ],
                    child: OffsetFullButton(
                      icon: PhosphorIconsBold.video,
                      content: "watch now",
                      fn: () {
                        navigateToPage(
                          context,
                          _cList.results?.data?[rand].type == "movie"
                              ? "/movie/${_cList.results?.data?[rand].uuid ?? ""}"
                              : "/series/${_cList.results?.data?[rand].uuid ?? ""}",
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
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
                    height: 40,
                  ),
                ),
                const SizedBox(height: 16),
                const CupertinoActivityIndicator(color: Colors.white),
              ],
            ),
          ),
        ),
      );
    }
  }
}
