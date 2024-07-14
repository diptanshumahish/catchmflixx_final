import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CatchMFlixxSearch extends StatefulWidget {
  final String? defaultSearch;
  final Function(String value, bool search) onSearching;
  const CatchMFlixxSearch({
    super.key,
    required this.onSearching,
    this.defaultSearch,
  });

  @override
  State<CatchMFlixxSearch> createState() => _CatchMFlixxSearchState();
}

class _CatchMFlixxSearchState extends State<CatchMFlixxSearch> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final translation = AppLocalizations.of(context)!;

    return SliverToBoxAdapter(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(size.height / 40),
            child: Column(
              children: [
                CupertinoSearchTextField(
                  prefixIcon:
                      const PhosphorIcon(PhosphorIconsRegular.magnifyingGlass),
                  controller: searchController,
                  itemColor: Colors.white,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: const PhosphorIcon(PhosphorIconsLight.xCircle),
                  placeholder: widget.defaultSearch ?? translation.searchFor,
                  style: TextStyles.formSubTitle,
                  onChanged: (val) {
                    if (val.isEmpty) {
                      widget.onSearching(val, false);
                    } else {
                      widget.onSearching(val, true);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
