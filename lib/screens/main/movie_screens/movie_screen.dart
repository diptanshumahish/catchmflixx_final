import 'package:catchmflixx/api/content/common.dart';
import 'package:catchmflixx/constants/images.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/models/content/movie/movie.model.dart';
import 'package:catchmflixx/screens/main/home_main.dart';
import 'package:catchmflixx/utils/genres/return_genres.dart';
import 'package:catchmflixx/widgets/cast/cast_render.dart';

import 'package:catchmflixx/widgets/common/flex/flex_items.dart';
import 'package:catchmflixx/widgets/content/movie/movie_top_bar.dart';
import 'package:catchmflixx/widgets/content/trailer/trailer_card.dart';
import 'package:catchmflixx/widgets/language/languages_available.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';

bool _isLoading = true;
MovieFullModel _movies = MovieFullModel();

class MovieScreen extends StatefulWidget {
  final String uuid;
  const MovieScreen({super.key, required this.uuid});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    ContentManager ct = ContentManager();
    MovieFullModel data = await ct.getMovie(widget.uuid);
    if (data.success!) {
      setState(() {
        _movies = data;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _movies = MovieFullModel(data: null, success: false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final translation = AppLocalizations.of(context)!;

    if (_isLoading == false && _movies.success == true) {
      return Scaffold(
          backgroundColor: Colors.black,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar.large(
                stretch: true,
                backgroundColor: Colors.black,
                title: Text(
                  _movies.data?.contentmeta?.title ?? "",
                  style: TextStyles.cardHeading,
                ),
                leading: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: const BaseMain(),
                              type: PageTransitionType.leftToRight));
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
                expandedHeight: size.height / 1.4,
                flexibleSpace: MovieTopBar(
                  act: () {
                    getData();
                  },
                  movieID: _movies.data?.uuid ?? "",
                  id: _movies.data?.videos?.videoUuid ?? "",
                  censor: _movies.data?.censor ?? "UA",
                  imgLink: _movies.data?.videos?.thumbnail ?? "",
                  title: _movies.data?.contentmeta?.title ?? "",
                  subTitle: _movies.data?.contentmeta?.description ?? "",
                  playId: _movies.data?.videos?.url ?? "",
                  addList: _movies.data?.watchlater ?? false,
                  releaseDate: _movies.data?.releaseDate ?? "",
                  duration: _movies.data?.videos!.durationMinutes ?? 0,
                  progress: _movies.data?.videos?.progress ?? 0,
                  type: '',
                ),
              ),
              SliverToBoxAdapter(
                child: Animate(
                  effects: const [
                    FadeEffect(delay: Duration(milliseconds: 900))
                  ],
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.height / 40),
                    child: FlexItems(widgetList: [
                      Text.rich(TextSpan(children: [
                        TextSpan(
                            text: translation.genre,
                            style: TextStyles.formSubTitle),
                        const TextSpan(
                            text: " : ", style: TextStyles.formSubTitle),
                        TextSpan(
                            text: returnGenres(_movies.data!.genres!),
                            style: TextStyles.smallSubText)
                      ]))
                    ], space: 5),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Animate(
                  effects: const [
                    FadeEffect(delay: Duration(milliseconds: 1000))
                  ],
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.height / 40,
                        vertical: size.height / 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translation.trailor,
                          style: TextStyles.headingsForSections,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TrailerCard(
                          poster: _movies.data?.videos?.thumbnail ?? "",
                          title: _movies.data?.contentmeta?.title ?? "",
                          playId: _movies.data?.videos?.trailer ?? "",
                        )
                      ],
                    ),
                  ),
                ),
              ),
              CastRender(uuid: _movies.data?.uuid ?? ""),
              LanguagesAvailable(uuid: _movies.data?.uuid ?? "")
            ],
          ));
    } else {
      return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.transparent,
                  highlightColor: Colors.white,
                  period: const Duration(seconds: 2),
                  child: SvgPicture.asset(
                    CatchMFlixxImages.textLogo,
                    height: 30,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const CupertinoActivityIndicator(
                  color: Colors.white,
                  radius: 8,
                )
              ],
            ),
          ));
    }
  }
}
