import 'package:catchmflixx/api/content/common.dart';
import 'package:catchmflixx/constants/images.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/models/content/series/seasons.model.dart';
import 'package:catchmflixx/screens/main/series/generate_season_sections.dart';
import 'package:catchmflixx/utils/genres/return_series_genre.dart';
import 'package:catchmflixx/widgets/cast/cast_render.dart';
import 'package:catchmflixx/widgets/common/flex/flex_items.dart';
// import 'package:catchmflixx/widgets/content/movie/movie_top_bar.dart';
import 'package:catchmflixx/widgets/content/series/series_top_bar.dart';
import 'package:catchmflixx/widgets/content/trailer/trailer_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

SeriesSeasons _movies = SeriesSeasons();
bool _isLoading = true;

class SeriesScreen extends StatefulWidget {
  final String uuid;
  const SeriesScreen({super.key, required this.uuid});

  @override
  State<SeriesScreen> createState() => _SeriesScreenState();
}

class _SeriesScreenState extends State<SeriesScreen> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    ContentManager ct = ContentManager();
    SeriesSeasons data = await ct.getSeasonsData(widget.uuid);
    if (data.success!) {
      setState(() {
        _isLoading = false;
        _movies = data;
      });
    }
  }

  @override
  void dispose() {
    _isLoading = true;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final translation = AppLocalizations.of(context)!;
    return Scaffold(
        backgroundColor: Colors.black,
        body: _isLoading == true
            ? Center(
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
              )
            : CustomScrollView(
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
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                    expandedHeight: size.height / 1.3,
                    flexibleSpace: SeriesTopBar(
                      noEp: _movies.data!.seasons!.first.noOfEpisodes??0,
                      act: () {
                        getData();
                      },
                      id: _movies.data?.uuid ?? "",
                      releaseDate: _movies.data?.releaseDate ?? "",
                      censor: _movies.data?.censor ?? "UA",
                      imgLink: _movies.data?.thumbnail ?? "",
                      title: _movies.data?.contentmeta?.title ?? "",
                      subTitle: _movies.data?.contentmeta?.description ?? "",
                      playId: _movies.data?.trailer ?? "",
                      addList: _movies.data?.watchlater ?? false,
                      type: 'series',
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.height / 40),
                      child: FlexItems(widgetList: [
                        Text.rich(TextSpan(children: [
                          TextSpan(
                              text: translation.genre,
                              style: TextStyles.formSubTitle),
                          const TextSpan(
                              text: " : ", style: TextStyles.formSubTitle),
                          TextSpan(
                              text: returnSeriesGenres(_movies.data?.genres!),
                              style: TextStyles.smallSubText)
                        ])),
                        // CastData(
                        //     uuid: _movies.data!.uuid ?? "",
                        //     castWord: translation.cast),
                      ], space: 5),
                    ),
                  ),
                  SliverToBoxAdapter(
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
                            poster: _movies.data?.thumbnail ?? "",
                            title: _movies.data?.contentmeta?.title ?? "",
                            playId: _movies.data?.trailer ?? "",
                          )
                        ],
                      ),
                    ),
                  ),
                  GenerateSeasonSections(seasons: _movies.data?.seasons ?? []),
                  
                  CastRender(uuid: _movies.data?.uuid ?? ""),
                  // LanguagesAvailable(uuid: _movies.data?.uuid ?? "")
                  // SliverToBoxAdapter(
                  //   child: Row(
                  //     children: [Container()],
                  //   ),
                  // ),
                ],
              ));
  }
}
