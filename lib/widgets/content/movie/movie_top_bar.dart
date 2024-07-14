import 'package:catchmflixx/api/user/profile/profile_api.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/screens/onboard/screen/onboard_screen.dart';
import 'package:catchmflixx/screens/start/later_verify.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/state/user/login/user.login.response.state.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:catchmflixx/widgets/common/buttons/full_button.dart';
import 'package:catchmflixx/widgets/common/buttons/secondary_full_button.dart';
import 'package:catchmflixx/widgets/common/flex/flex_items.dart';
import 'package:catchmflixx/widgets/common/glyph/glyph_catchmflixx_originals.dart';
import 'package:catchmflixx/widgets/common/glyph/glyph_censor.dart';
import 'package:catchmflixx/widgets/common/glyph/glyph_year.dart';
import 'package:catchmflixx/widgets/player/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool _added = false;

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
      required this.censor,
      required this.addList,
      required this.releaseDate});

  @override
  ConsumerState<MovieTopBar> createState() => _MovieTopBarState();
}

class _MovieTopBarState extends ConsumerState<MovieTopBar> {
  @override
  void initState() {
    setState(() {
      _added = widget.addList;
    });
    super.initState();
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
                Animate(
                  effects: const [
                    FadeEffect(delay: Duration(milliseconds: 600))
                  ],
                  child: FullButton(
                      icon: PhosphorIconsFill.play,
                      content: widget.type == "series"
                          ? "Watch trailer"
                          : (progressSeconds > 0)
                              ? "Resume"
                              : translation.playNow,
                      fn: () async {
                        if (user is LoadedUserLoginResponseState &&
                            user.userLoginResponse.isLoggedIn!) {
                          Navigator.push(
                            context,
                            PageTransition(
                              child: PlayerScreen(
                                act: () {
                                  widget.act();
                                },
                                seekTo: widget.progress ?? 0,
                                type: widget.type == "series" ? "Trailer" : "",
                                title: widget.type == "series"
                                    ? "Trailer"
                                    : widget.title,
                                details: widget.subTitle,
                                id: widget.id,
                                playLink: widget.playId,
                              ),
                              type: PageTransitionType.leftToRight,
                            ),
                          );
                        } else {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String? data = prefs.getString("temp_login_mail");
                          if (data != null) {
                            ToastShow.returnToast(
                                "You have to verify your email to start watching, please verify it from your email");
                            Navigator.push(
                              context,
                              PageTransition(
                                child: const LaterVerifyScreen(),
                                type: PageTransitionType.leftToRight,
                              ),
                            );
                            return;
                          }
                          ToastShow.returnToast(translation.loginToView);
                          Navigator.push(
                            context,
                            PageTransition(
                              child: const OnboardScreen(),
                              type: PageTransitionType.leftToRight,
                            ),
                          );
                        }
                      }),
                ),
                const SizedBox(
                  height: 15,
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
                        setState(() {
                          _added = true;
                        });
                      } else {
                        await p.removeFromWatchLater(widget.movieID != null
                            ? widget.movieID!
                            : widget.id);
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
                Animate(
                  effects: const [
                    FadeEffect(delay: Duration(milliseconds: 800))
                  ],
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: FlexItems(
                        widgetList: [
                          GlyphYear(year: widget.releaseDate),
                          GlyphSensor(censorType: widget.censor),
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
