import 'package:catchmflixx/api/content/common.dart';
import 'package:catchmflixx/constants/images.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/models/content/series/seasons.model.dart';
import 'package:catchmflixx/screens/main/series/generate_season_sections.dart';
import 'package:catchmflixx/utils/genres/return_series_genre.dart';
import 'package:catchmflixx/widgets/cast/cast_render.dart';
import 'package:catchmflixx/widgets/content/series/series_top_bar.dart';
import 'package:catchmflixx/widgets/content/trailer/trailer_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

SeriesSeasons _movies = SeriesSeasons();
bool _isLoading = true;

class SeriesScreen extends StatefulWidget {
  final String uuid;
  const SeriesScreen({super.key, required this.uuid});

  @override
  State<SeriesScreen> createState() => _SeriesScreenState();
}

class _SeriesScreenState extends State<SeriesScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    getData();
    super.initState();
  }

  getData() async {
    ContentManager ct = ContentManager();
    SeriesSeasons? data = await ct.getSeasonsData(widget.uuid);
    if (data != null && data.success!) {
      setState(() {
        _isLoading = false;
        _movies = data;
      });
      _fadeController.forward();
      _slideController.forward();
    }
  }

  @override
  void dispose() {
    _isLoading = true;
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final translation = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading == true
          ? _buildLoadingScreen()
          : _buildMainContent(size, translation),
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1a1a1a), Colors.black],
        ),
      ),
      child: Center(
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
                height: 40,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const CupertinoActivityIndicator(
                color: Colors.white,
                radius: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(Size size, AppLocalizations translation) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildSliverAppBar(size),
        _buildGenreSection(size, translation),
        _buildTrailerSection(size, translation),
        GenerateSeasonSections(seasons: _movies.data?.seasons ?? []),
        CastRender(uuid: _movies.data?.uuid ?? ""),
      ],
    );
  }

  Widget _buildSliverAppBar(Size size) {
    return SliverAppBar.large(
      stretch: true,
      backgroundColor: Colors.black,
      elevation: 0,
      title: FadeTransition(
        opacity: _fadeAnimation,
        child: Text(
          _movies.data?.contentmeta?.title ?? "",
          style: TextStyles.cardHeading.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
      expandedHeight: size.height / 1.3,
      flexibleSpace: SeriesTopBar(
        noEp: _movies.data!.seasons!.first.noOfEpisodes ?? 0,
        act: () => getData(),
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
    );
  }

  Widget _buildGenreSection(Size size, AppLocalizations translation) {
    return SliverToBoxAdapter(
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: size.height / 40,
              vertical: size.height / 60,
            ),
            padding: EdgeInsets.all(size.height / 50),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    translation.genre,
                    style: TextStyles.formSubTitle.copyWith(
                      fontSize: 12,
                      color: Colors.red.shade300,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    returnSeriesGenres(_movies.data?.genres!),
                    style: TextStyles.smallSubText.copyWith(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrailerSection(Size size, AppLocalizations translation) {
    return SliverToBoxAdapter(
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: size.height / 40,
              vertical: size.height / 60,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      translation.trailor,
                      style: TextStyles.headingsForSections.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: TrailerCard(
                      poster: _movies.data?.thumbnail ?? "",
                      title: _movies.data?.contentmeta?.title ?? "",
                      playId: _movies.data?.trailer ?? "",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
