import 'package:catchmflixx/api/content/common.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/models/content/search.list.model.dart';
import 'package:catchmflixx/screens/main/movie_screens/movie_screen.dart';
import 'package:catchmflixx/screens/main/series/series_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:async';

import 'package:page_transition/page_transition.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vibration/vibration.dart';

ContentList _contentList = ContentList(count: 0);
bool _searching = true;

class SearchResults extends StatefulWidget {
  final String searchTerms;
  const SearchResults({super.key, required this.searchTerms});

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  late String _searchTerms;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchTerms = widget.searchTerms;
    getData();
  }

  @override
  void didUpdateWidget(SearchResults oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchTerms != widget.searchTerms) {
      _searchTerms = widget.searchTerms;
      _onSearchTermChanged();
    }
  }

  void _onSearchTermChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      getData();
    });
  }

  getData() async {
    setState(() {
      _searching = true;
    });
    ContentManager c = ContentManager();
    final data = await c.searchContent(_searchTerms);
    if (data.results!.success!) {
      setState(() {
        _contentList = data;
        _searching = false;
      });
    } else {
      setState(() {
        _searching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final translation = AppLocalizations.of(context)!;
    final cards = _contentList.results?.data ?? [];

    return SliverToBoxAdapter(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: size.height / 40, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${translation.showingContentFor} '$_searchTerms'",
              style: TextStyles.formSubTitle,
            ),
            _searching
                ? SizedBox(
                    height: 200,
                    width: size.width,
                    child: const Center(
                      child: CupertinoActivityIndicator(
                        color: Colors.white,
                        radius: 12,
                      ),
                    ),
                  )
                : cards.isNotEmpty
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 7 / 16,
                          mainAxisSpacing: 12.0,
                          crossAxisSpacing: 12.0,
                        ),
                        itemCount: cards.length,
                        itemBuilder: (context, idx) {
                          return Animate(
                            effects: [
                              FadeEffect(
                                  delay: Duration(milliseconds: (idx) * 50))
                            ],
                            child: GestureDetector(
                              onTap: () {
                                Vibration.vibrate(amplitude: 30, duration: 50);
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    duration: const Duration(milliseconds: 400),
                                    isIos: true,
                                    curve: Curves.bounceInOut,
                                    child: cards[idx].type == "movie"
                                        ? MovieScreen(
                                            uuid: cards[idx].uuid ?? "",
                                          )
                                        : SeriesScreen(
                                            uuid: cards[idx].uuid ?? ""),
                                    type: PageTransitionType.leftToRight,
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Stack(
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 9 / 16,
                                          child: Opacity(
                                            opacity: 0.9,
                                            child: Image.network(
                                              fit: BoxFit.cover,
                                              cards[idx].thumbnail ??
                                                  "https://img.playbook.com/Axh_gEkgZbsvB1VDuXm4GNvbjXXu2RUUqwToXJEJ8ZQ/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzM5NTk3ODYx/LWQ1MzItNDZmMC1i/ZDhmLTQ2NjRiYjcz/NjZmMQ",
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                            top: 0,
                                            left: 0,
                                            child: cards[idx].watchlater == true
                                                ? Container(
                                                    height: 42,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.greenAccent,
                                                    ),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Row(
                                                        children: [
                                                          PhosphorIcon(
                                                            PhosphorIconsBold
                                                                .playlist,
                                                            color: Colors.black,
                                                            size: 16,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox.shrink())
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    cards[idx].metaData?.title ?? "",
                                    style:
                                        TextStyles.cardHeadingForSmallerScreens,
                                  ),
                                  Text(
                                    cards[idx].type == "web_series"
                                        ? "web series"
                                        : "movie",
                                    style: TextStyles.smallSubText,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : SizedBox(
                        height: 200,
                        width: size.width,
                        child: Center(
                          child: Text(
                            translation.sorryNoResults,
                            style: TextStyles.cardHeading,
                          ),
                        ),
                      ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
