import 'package:catchmflixx/widgets/ads/ads_module.dart';
import 'package:catchmflixx/widgets/common/cards/redesigned_genre_car.dart';
import 'package:catchmflixx/widgets/search/search_results.dart';
import 'package:catchmflixx/widgets/search/search_top.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final _genreList = [
  {
    "image":
        "https://img.playbook.com/08xI9xg7ygQvPaBeTcJllaXXCK-wVyiDkBRe_1sxeu4/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzg2YzUyZTll/LTcxNjUtNDU5MS1i/MWY1LWIxNjQ3NWJk/MGMyZQ",
    "name": "Horror",
    "desc": "The thrills and chills of nightmares"
  },
  {
    "image":
        "https://img.playbook.com/he2XwRaA2GCHK9W647yYi6EevGcNFM4gu_5zA8pggrs/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljL2I4OTY0MzZj/LWY3NDgtNDViMC04/Njk0LWZmZDcyMzk2/NmUzNQ",
    "name": "Comedy",
    "desc": "Laughter is the best medicine (and genre)"
  },
  {
    "image":
        "https://img.playbook.com/gaBoQYUD1oXjD8qGLb5Tv50LFjnz6LSvNH0h356U6OU/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljL2E2ODA3ZDE1/LWJlNTUtNDlmOS1i/YmMzLTcwZTE3N2U0/MjFiOA",
    "name": "Action",
    "desc": "Fast-paced excitement and adrenaline rush"
  },
  {
    "image":
        "https://img.playbook.com/HGmawb1RtmjW5IuvHBPhvHW806BSrTJlXAg3v00ISzQ/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzNmMTRjODM5/LTQwOTMtNDdmMi1i/OTA1LTZkYjZjYTk3/OWI5ZQ",
    "name": "Thriller",
    "desc": "Suspenseful buildup that keeps you on the edge of your seat"
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
                            childAspectRatio: 16 / 12,
                            crossAxisCount: 2),
                    itemBuilder: (ctx, idx) => ModifiedGenreCard(
                        poster: _genreList[idx]["image"]!,
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
