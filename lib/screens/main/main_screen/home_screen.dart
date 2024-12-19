import 'package:catchmflixx/constants/images.dart';
import 'package:catchmflixx/widgets/content/activity/watch_history_mini.dart';
import 'package:catchmflixx/widgets/content/activity/watch_later_mini.dart';
import 'package:catchmflixx/widgets/home/home_first.dart';
import 'package:catchmflixx/widgets/home/top_bar_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final translation = AppLocalizations.of(context)!;
    return CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
      SliverAppBar.large(
          stretch: true,
          leading: const SizedBox.shrink(),
          expandedHeight: 550,
          backgroundColor: Colors.black45,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                CatchMFlixxImages.textLogo,
                height: 30,
              ),
            ],
          ),
          centerTitle: true,
          flexibleSpace: const TopBarBanner()),
      const HomeFirst(),
      const WatchHistoryComponent(),
      const WatchLaterComponent(),
      // GenresSection(
      //   sectionHeading: translation.genres,
      //   genreCards: [
      //     GenreCard(
      //         poster: CatchMFLixxImages.genre1,
      //         fullDetailsId: "",
      //         title: "Horror",
      //         subTitle: "the fears of truth"),
      //     GenreCard(
      //         poster: CatchMFLixxImages.genre2,
      //         fullDetailsId: "",
      //         title: "Thriller",
      //         subTitle: "All that seems so easy"),
      //     GenreCard(
      //         poster: CatchMFLixxImages.testBanner,
      //         fullDetailsId: "",
      //         title: "Action",
      //         subTitle: "fight fight"),
      //     GenreCard(
      //         poster: CatchMFLixxImages.topBanner,
      //         fullDetailsId: "",
      //         title: "Comedy",
      //         subTitle: "laugh out loud"),
      //     GenreCard(
      //         poster: CatchMFLixxImages.genre1,
      //         fullDetailsId: "",
      //         title: "Romance",
      //         subTitle: "Out in love"),
      //   ],
      // ),
      const SliverToBoxAdapter(
        child: SizedBox(
          height: 200,
        ),
      )
    ]);
  }
}
