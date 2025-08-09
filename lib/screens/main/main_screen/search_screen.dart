import 'package:catchmflixx/widgets/ads/ads_module.dart';
import 'package:catchmflixx/widgets/common/recommendation/picked_for_you.dart';
import 'package:catchmflixx/widgets/search/search_results.dart';
import 'package:catchmflixx/widgets/search/search_top.dart';
import 'package:catchmflixx/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isSearching = false;
  String _searchData = "";

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Search Header
        SearchTop(
          searchText: translation.navDiscover,
          onSearching: (value, search) {
            if (mounted) {
              setState(() {
                isSearching = search;
                _searchData = value;
              });
            }
          },
        ),
        
        if (isSearching) 
          SearchResults(searchTerms: _searchData),
        
        if (!isSearching) ...[
         const  SliverToBoxAdapter(
            child:  Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: AppText(
                "Discover",
                variant: AppTextVariant.headline,
              ),
            ),
          ),

         const  SliverToBoxAdapter(
            child:  Padding(
              padding: EdgeInsets.fromLTRB(16, 2, 5, 2),
              child: AppText(
                "Recommended for You",
                variant: AppTextVariant.sectionTitle,
              ),
            ),
          ),

          const PickedForYou(),
        ],
        
        // Ads Section with better spacing
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: AdsModule(),
          ),
        ),
        
        // Bottom Spacing
        const SliverToBoxAdapter(
          child: SizedBox(height: 120),
        ),
      ],
    );
  }
}
