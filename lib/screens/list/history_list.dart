import 'package:catchmflixx/api/user/user_activity/user.activity.dart';
import 'package:catchmflixx/api/user/user_activity/watch_history_list.model.dart';
import 'package:catchmflixx/constants/images.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/utils/datetime/format_watched_date.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';

UserActivityHistory _wl = UserActivityHistory();

class HistoryListWidget extends StatefulWidget {
  const HistoryListWidget({super.key});

  @override
  State<HistoryListWidget> createState() => _HistoryListWidgetState();
}

class _HistoryListWidgetState extends State<HistoryListWidget> {
  bool _isLoading = true;

  getData() async {
    UserActivity u = UserActivity();
    final data = await u.getWatchHistory();
    if (data.success!) {
      setState(() {
        _wl = data;
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  stretch: true,
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const PhosphorIcon(
                        PhosphorIconsRegular.arrowLeft,
                        color: Colors.white,
                      )),
                  backgroundColor: Colors.black,
                  title: const Text(
                    "Watch history",
                    style: TextStyles.headingsForSections,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Text(
                      "Your watch history",
                      style: TextStyles.formSubTitle,
                    ),
                  ),
                ),
                SliverList.builder(
                  itemBuilder: (context, idx) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      child: Animate(
                        effects: [
                          FadeEffect(
                              delay: Duration(milliseconds: idx * 90),
                              curve: Curves.easeInOut)
                        ],
                        child: GestureDetector(
                          onTap: () {
                            navigateToPage(
                                context,
                                _wl.data?[idx].contentType == "movie"
                                    ? "/movie/${_wl.data?[idx].contentUuid ?? ''}"
                                    : "/series/${_wl.data?[idx].contentUuid ?? ''}");
                          },
                          child: Row(
                            mainAxisAlignment: size.width > 540
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: size.width > 540 ? 50 : 20,
                                child: Text(
                                  '${idx + 1} .',
                                  style: TextStyles.cardHeading,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Stack(
                                        children: [
                                          Opacity(
                                            opacity: 0.8,
                                            child: Image.network(
                                              filterQuality:
                                                  FilterQuality.medium,
                                              _wl.data?[idx].video?.thumbnail ??
                                                  "",
                                              width: size.width > 540
                                                  ? size.width / 4
                                                  : size.width / 2.6,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const Positioned.fill(
                                              child: Center(
                                            child: PhosphorIcon(
                                              PhosphorIconsDuotone.play,
                                              duotoneSecondaryColor:
                                                  Colors.white,
                                              color: Colors.white,
                                              duotoneSecondaryOpacity: 0.5,
                                              size: 30,
                                            ),
                                          )),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              height: 4,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: Colors.white24,
                                                  borderRadius:
                                                      BorderRadius.circular(2)),
                                              child: FractionallySizedBox(
                                                alignment: Alignment.topLeft,
                                                widthFactor: (_wl.data?[idx]
                                                            .progressSeconds ??
                                                        0) /
                                                    ((_wl.data?[idx]
                                                                .durationMinutes ??
                                                            0) *
                                                        60),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            _wl.data?[idx].contentType ==
                                                    "web_series"
                                                ? "web series"
                                                : "movie",
                                            style: TextStyles.smallSubText,
                                          ),
                                          SizedBox(
                                            width: size.width / 3,
                                            child: Text(
                                              _wl.data?[idx].contentName ?? "",
                                              style: TextStyles.cardHeading,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(
                                            width: size.width / 2.5,
                                            child: Text(
                                              formatWatchedDate(DateTime.parse(
                                                  _wl.data?[idx]
                                                          .lastWatchedTime ??
                                                      "")),
                                              style: TextStyles.smallSubText,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: _wl.data?.length ?? 0,
                ),
                if (_wl.data!.isEmpty)
                  SliverToBoxAdapter(
                    child: Animate(
                      effects: const [FadeEffect()],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(CatchMFlixxImages.nope),
                            const SizedBox(
                              height: 50,
                            ),
                            const Text(
                              "Start watching content, to see them here",
                              style: TextStyles.cardHeading,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  const SliverToBoxAdapter(
                    child: SizedBox.shrink(),
                  )
              ],
            ),
    );
  }
}
