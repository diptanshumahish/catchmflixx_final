import 'package:catchmflixx/api/user/profile/profile_api.dart';
import 'package:catchmflixx/api/user/user_activity/watch_later_list.dart';
import 'package:catchmflixx/constants/images.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/screens/main/movie_screens/movie_screen.dart';
import 'package:catchmflixx/screens/main/series/series_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

WatchLaterList _wl = WatchLaterList(data: [], success: false);

class MyToWatchList extends StatefulWidget {
  const MyToWatchList({super.key});

  @override
  State<MyToWatchList> createState() => _MyToWatchListState();
}

class _MyToWatchListState extends State<MyToWatchList> {
  bool _isLoading = true;

  getData() async {
    ProfileApi p = ProfileApi();
    WatchLaterList data = await p.gatWatchLater();
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
                    "To Watch list",
                    style: TextStyles.headingsForSections,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Text(
                      "Here is a list of all the movies and web series that you have added to your personal list",
                      style: TextStyles.formSubTitle,
                    ),
                  ),
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
                              "No content yet",
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
                            Navigator.push(
                              context,
                              PageTransition(
                                duration: const Duration(milliseconds: 400),
                                isIos: true,
                                curve: Curves.bounceInOut,
                                child: _wl.data?[idx].type == "movie"
                                    ? MovieScreen(
                                        uuid: _wl.data?[idx].uuid ?? "",
                                      )
                                    : SeriesScreen(
                                        uuid: _wl.data?[idx].uuid ?? ""),
                                type: PageTransitionType.leftToRight,
                              ),
                            );
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
                                              _wl.data?[idx].thumbnail ?? "",
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
                                          ))
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
                                            _wl.data?[idx].type == "web_series"
                                                ? "web series"
                                                : "movie",
                                            style: TextStyles.smallSubText,
                                          ),
                                          SizedBox(
                                            width: size.width / 3,
                                            child: Text(
                                              _wl.data?[idx].metaData?.title ??
                                                  "",
                                              style: TextStyles.cardHeading,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            width: size.width / 2.5,
                                            child: Text(
                                              _wl.data?[idx].metaData
                                                      ?.description ??
                                                  "",
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
              ],
            ),
    );
  }
}
