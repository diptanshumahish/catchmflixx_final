import 'package:catchmflixx/models/content/series/seasons.model.dart';
import 'package:catchmflixx/screens/main/movie_screens/SeasonSection.dart';
import 'package:flutter/material.dart';

class GenerateSeasonSections extends StatefulWidget {
  final List<Seasons> seasons;
  const GenerateSeasonSections({super.key, required this.seasons});

  @override
  State<GenerateSeasonSections> createState() => _GenerateSeasonSectionsState();
}

class _GenerateSeasonSectionsState extends State<GenerateSeasonSections> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
          children: widget.seasons
              .map((e) => SeasonSection(
                  sectionHeading: e.subTitle ?? "",
                  uuid: e.suuid ?? "",
                  sectionDetails: e.subDescription ?? ""))
              .toList()),
    );
  }
}
