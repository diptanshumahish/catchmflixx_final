import 'package:catchmflixx/api/content/common.dart';
import 'package:catchmflixx/api/user/profile/profile_api.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/models/content/series/continue.watching.model.dart';
import 'package:catchmflixx/screens/payments/renting_screen.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/state/user/login/user.login.response.state.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_full_button.dart';
import 'package:catchmflixx/widgets/common/buttons/secondary_full_button.dart';
import 'package:catchmflixx/widgets/common/flex/flex_items.dart';
import 'package:catchmflixx/widgets/common/glyph/glyph_catchmflixx_originals.dart';
import 'package:catchmflixx/widgets/common/glyph/glyph_censor.dart';
import 'package:catchmflixx/widgets/common/glyph/glyph_price.dart';
import 'package:catchmflixx/widgets/common/glyph/glyph_rented.dart';
import 'package:catchmflixx/widgets/common/glyph/glyph_year.dart';
import 'package:catchmflixx/widgets/player/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool _added = false;
CurrentWatching _cw = CurrentWatching(success: false);

class MovieTopBar extends ConsumerStatefulWidget {
  final String imgLink;
  final String title;
  final String subTitle;
  final String playId;
  final String id;
  final bool addList;
  final String type;
  final String releaseDate;
  final String censor;
  final String? movieID;
  final int? duration;
  final int? progress;
  final VoidCallback act;
  final bool? userRented;
  final bool? isFree;
  const MovieTopBar(
      {super.key,
      this.movieID,
      required this.imgLink,
      required this.id,
      required this.type,
      required this.title,
      required this.subTitle,
      required this.playId,
      required this.act,
      this.duration,
      this.progress,
      this.isFree,
      this.userRented,
      required this.censor,
      required this.addList,
      required this.releaseDate});

  @override
  ConsumerState<MovieTopBar> createState() => _MovieTopBarState();
}

class _MovieTopBarState extends ConsumerState<MovieTopBar> {
  @override
  void initState() {
    if (widget.type == "series") {
      getData();
    }
    setState(() {
      _added = widget.addList;
    });
    super.initState();
  }

  getData() async {
    ContentManager ct = ContentManager();
    final dat = await ct.continueWatching(widget.id);
    if (dat.success == true) {
      setState(() {
        _cw = dat;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = ref.read(userLoginProvider);
    final translation = AppLocalizations.of(context)!;

    final totalDurationSeconds = (widget.duration ?? 0) * 60;
    final progressSeconds = widget.progress ?? 0;
    final remainingSeconds = totalDurationSeconds - progressSeconds;
    final progressPercent = totalDurationSeconds > 0
        ? (progressSeconds / totalDurationSeconds)
        : 0.0;

    return FlexibleSpaceBar(
        background: Stack(
      children: [
        Animate(
          effects: const [FadeEffect(delay: Duration(milliseconds: 100))],
          child: Image.network(
            widget.imgLink,
            height: size.height / 1.4,
            width: size.width,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54, Colors.black])),
        ),
        Padding(
          padding: EdgeInsets.all(size.height / 40),
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Animate(
                    effects: const [FadeEffect()],
                    child: const CatchMFlixxOriginals()),
                const SizedBox(
                  height: 5,
                ),
                Animate(
                  effects: const [
                    FadeEffect(delay: Duration(milliseconds: 200))
                  ],
                  child: Text(
                    widget.title,
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
                    FadeEffect(delay: Duration(milliseconds: 400))
                  ],
                  child: Text(
                    widget.subTitle,
                    style: TextStyles.smallSubText,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                (widget.progress != 0 && widget.progress != null)
                    ? Animate(
                        effects: const [
                          FadeEffect(delay: Duration(milliseconds: 300))
                        ],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 4,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(2)),
                              child: FractionallySizedBox(
                                alignment: Alignment.topLeft,
                                widthFactor: progressPercent,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              formatDuration(remainingSeconds),
                              style: TextStyles.smallSubText,
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(
                  height: 5,
                ),
                (widget.isFree == true || widget.userRented == true)
                    ? Animate(
                        effects: const [
                          FadeEffect(delay: Duration(milliseconds: 600))
                        ],
                        child: OffsetFullButton(
                            icon: PhosphorIconsFill.video,
                            content: widget.type == "series"
                                ? "Watch trailer"
                                : (progressSeconds > 0)
                                    ? "Resume"
                                    : translation.playNow,
                            fn: () async {
                              if (user is LoadedUserLoginResponseState &&
                                  user.userLoginResponse.isLoggedIn!) {
                                navigateToPage(context, "/player",
                                    data: PlayerScreen(
                                      act: () {
                                        widget.act();
                                      },
                                      seekTo: widget.progress ?? 0,
                                      type: widget.type == "series"
                                          ? "Trailer"
                                          : "",
                                      title: widget.type == "series"
                                          ? "Trailer"
                                          : widget.title,
                                      details: widget.subTitle,
                                      id: widget.id,
                                      playLink: widget.playId,
                                    ));
                              } else {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String? data =
                                    prefs.getString("temp_login_mail");
                                if (data != null) {
                                  ToastShow.returnToast(
                                      "You have to verify your email to start watching, please verify it from your email");
                                  // navigateToPage(
                                  //     context, const LaterVerifyScreen());

                                  return;
                                }
                                ToastShow.returnToast(translation.loginToView);
                                navigateToPage(context, "/onboard");
                              }
                            }),
                      )
                    : OffsetFullButton(
                        icon: PhosphorIconsFill.sparkle,
                        content: "Rent to watch",
                        fn: () {
                          navigateToPage(context, "/movie-rent",
                              data: RentingScreen(
                                  act: () {},
                                  title: widget.title,
                                  img: widget.imgLink,
                                  id: widget.movieID!));
                        }),
                const SizedBox(
                  height: 8,
                ),
                if (_cw.success == true && widget.type == "series")
                  OffsetFullButton(
                    content: "Resume watching",
                    fn: () {
                      navigateToPage(context, "/player",
                          data: PlayerScreen(
                              title: _cw.data?.subTitle ?? "",
                              details: _cw.data?.subDescription ?? "",
                              playLink: _cw.data?.url ?? "",
                              id: _cw.data?.videoUuid ?? "",
                              seekTo: _cw.data?.progress ?? 0,
                              type: "series",
                              act: () {
                                getData();
                              }));
                    },
                    icon: PhosphorIconsFill.play,
                  ),
                if (_cw.success == true && widget.type == "series")
                  const SizedBox(
                    height: 5,
                  ),
                Animate(
                  effects: const [
                    FadeEffect(delay: Duration(milliseconds: 700))
                  ],
                  child: SecondaryFullButton(
                    content: _added
                        ? "Remove from watch later"
                        : "Add to watch later",
                    fn: () async {
                      ProfileApi p = ProfileApi();
                      if (_added == false) {
                        await p.addToWatchLater(widget.movieID != null
                            ? widget.movieID!
                            : widget.id);
                        await ref
                            .read(watchLaterProvider.notifier)
                            .updateState();
                        setState(() {
                          _added = true;
                        });
                      } else {
                        await p.removeFromWatchLater(widget.movieID != null
                            ? widget.movieID!
                            : widget.id);
                        await ref
                            .read(watchLaterProvider.notifier)
                            .updateState();
                        setState(() {
                          _added = false;
                        });
                      }
                    },
                    icon: Icon(_added
                        ? PhosphorIconsRegular.check
                        : PhosphorIconsRegular.playlist),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Animate(
                  effects: const [
                    FadeEffect(delay: Duration(milliseconds: 900))
                  ],
                  child: SecondaryFullButton(
                    content: "Share",
                    fn: () async {
                      final url = widget.type == "series"
                          ? "https://www.catchmflixx.com/en/watch/watch-now/series?id=${widget.movieID}"
                          : "https://www.catchmflixx.com/en/watch/watch-now/movie?id=${widget.movieID}";
                      await Share.shareUri(
                        Uri.parse(url),
                      );
                    },
                    icon: const Icon(PhosphorIconsFill.share),
                  ),
                ),
                Animate(
                  effects: const [
                    FadeEffect(delay: Duration(milliseconds: 800))
                  ],
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: FlexItems(
                        widgetList: [
                          GlyphYear(year: widget.releaseDate),
                          GlyphSensor(censorType: widget.censor),
                          GlyphPrice(isPaid: widget.isFree ?? false),
                          widget.isFree == true
                              ? const SizedBox.shrink()
                              : GlyphRented(
                                  isRented: widget.userRented ?? false)
                        ],
                        space: 10,
                        horizontal: true,
                      )),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  String formatDuration(int seconds) {
    final hour = (seconds ~/ 60) ~/ 60;
    final minutes = (hour > 0) ? (seconds / 60) ~/ 60 : seconds ~/ 60;
    if (hour != 0) {
      return '${hour}h ${minutes}m  remaining';
    }
    return '${minutes}m  remaining';
  }
}
