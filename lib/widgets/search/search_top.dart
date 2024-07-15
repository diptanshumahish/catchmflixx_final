import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchTop extends StatefulWidget {
  final String searchText;
  final String? defaultSearch;
  final Function(String value, bool search) onSearching;
  const SearchTop(
      {super.key,
      required this.searchText,
      this.defaultSearch,
      required this.onSearching});

  @override
  State<SearchTop> createState() => _SearchTopState();
}

class _SearchTopState extends State<SearchTop> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    return SliverAppBar(
      floating: true,
      stretch: true,
      backgroundColor: const Color.fromARGB(255, 13, 13, 14),
      automaticallyImplyLeading: false,
      title: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: CupertinoSearchTextField(
            prefixIcon:
                const PhosphorIcon(PhosphorIconsRegular.magnifyingGlass),
            controller: searchController,
            itemColor: Colors.white,
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            suffixIcon: const PhosphorIcon(PhosphorIconsLight.xCircle),
            placeholder: widget.defaultSearch ?? translation.searchFor,
            style: TextStyles.searchBox,
            onChanged: (val) {
              if (val.isEmpty) {
                widget.onSearching(val, false);
              } else {
                widget.onSearching(val, true);
              }
            },
          ),
        ),
      ),
    );
  }
}
