import 'package:catchmflixx/widgets/ads/ads_module.dart';
import 'package:catchmflixx/widgets/common/cards/redesigned_genre_car.dart';
import 'package:catchmflixx/widgets/search/search_results.dart';
import 'package:catchmflixx/widgets/search/search_top.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final _genreList = [
  {
    "image": "horror",
    "name": "Horror",
    "desc": "The thrills and chills of nightmares"
  },
  {
    "image": "comedy",
    "name": "Comedy",
    "desc": "Laughter is the best medicine (and genre)"
  },
  {
    "image": "action",
    "name": "Action",
    "desc": "Fast-paced excitement and adrenaline rush"
  },
  {
    "image": "thriller",
    "name": "Thriller",
    "desc": "Suspenseful buildup that keeps you on the edge of your seat"
  },
  {
    "image": "fantasy",
    "name": "Fantasy",
    "desc": "Magical worlds and creatures beyond imagination"
  },
  {
    "image": "science fiction",
    "name": "Science Fiction",
    "desc":
        "Futuristic technology, space exploration, and fantastical science concepts"
  },
  {
    "image": "mystery",
    "name": "Mystery",
    "desc": "Unraveling clues and solving puzzles to uncover the truth"
  },
  {
    "image": "romance",
    "name": "Romance",
    "desc": "Stories of love, connection, and happily ever afters"
  },
  {
    "image": "drama",
    "name": "Drama",
    "desc": "Exploring serious themes and human emotions"
  },
  {
    "image": "historical fiction",
    "name": "Historical Fiction",
    "desc": "Journeys through the past, bringing history to life"
  },
  {
    "image": "adventure",
    "name": "Adventure",
    "desc": "Exhilarating journeys and daring quests"
  },
  {
    "image": "dystopian",
    "name": "Dystopian",
    "desc": "Exploring dark futures and cautionary tales"
  },
  {
    "image": "crime",
    "name": "Crime",
    "desc":
        "Delving into the world of criminals, detectives, and the justice system"
  },
  {
    "image": "superhero",
    "name": "Superhero",
    "desc": "Caped crusaders and extraordinary abilities saving the day"
  },
  {
    "image": "supernatural",
    "name": "Supernatural",
    "desc":
        "The unknown realm beyond the natural world, with ghosts, spirits, and paranormal phenomena"
  },
  {
    "image": "psychological thriller",
    "name": "Psychological Thriller",
    "desc":
        "Exploring the depths of human psychology and suspense that messes with your mind"
  },
];
String _searchData = "";

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SearchTop(
          searchText: translation.navDiscover,
          onSearching: (value, search) {
            setState(() {
              isSearching = search;
              _searchData = value;
            });
          },
        ),
        isSearching == false
            ? const SliverToBoxAdapter(
                child: SizedBox.shrink(),
              )
            : SearchResults(searchTerms: _searchData),
        isSearching == false
            ? SliverPadding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.height / 40, vertical: 16),
                sliver: SliverGrid.builder(
                    itemCount: _genreList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 16 / 9,
                            crossAxisCount: 2),
                    itemBuilder: (ctx, idx) => ModifiedGenreCard(
                        poster:
                            "https://img.playbook.com/Axh_gEkgZbsvB1VDuXm4GNvbjXXu2RUUqwToXJEJ8ZQ/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzM5NTk3ODYx/LWQ1MzItNDZmMC1i/ZDhmLTQ2NjRiYjcz/NjZmMQ",
                        fullDetailsId: "  ",
                        title: _genreList[idx]["name"]!,
                        subTitle: _genreList[idx]["desc"]!)),
              )
            : const SliverToBoxAdapter(
                child: SizedBox.shrink(),
              ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: AdsModule(),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 100,
          ),
        ),
      ],
    );
  }
}
