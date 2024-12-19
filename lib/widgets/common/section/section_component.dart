import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/widgets/common/cards/section_card.dart';
import 'package:catchmflixx/widgets/common/cards/watched_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Section extends StatefulWidget {
  final String sectionHeading;
  final String sectionDetails;
  final List<SectionCard>? sectionCards;
  final List<WatchedCard>? watchedCards;
  final String showMore;
  const Section(
      {super.key,
      required this.sectionHeading,
      required this.showMore,
      this.watchedCards,
      required this.sectionDetails,
      this.sectionCards});

  @override
  _SectionState createState() => _SectionState();
}

class _SectionState extends State<Section> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final translation = AppLocalizations.of(context)!;

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(size.height / 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    widget.sectionHeading,
                    style: size.height > 840
                        ? TextStyles.headingsForSections
                        : TextStyles.headingsForSectionsForSmallerScreens,
                  ),
                ),
              ],
            ),
            Text(
              widget.sectionDetails,
              style: TextStyles.smallSubText,
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: widget.sectionCards != null
                    ? const EdgeInsets.symmetric(vertical: 10)
                    : EdgeInsets.zero,
                child: widget.sectionCards != null
                    ? Row(
                        children: widget.sectionCards!
                            .map((sectionCard) => Animate(
                                effects: const [FadeEffect()],
                                child: sectionCard))
                            .toList(),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: widget.watchedCards != null
                    ? const EdgeInsets.symmetric(vertical: 10)
                    : EdgeInsets.zero,
                child: widget.watchedCards != null
                    ? Row(
                        children: widget.watchedCards!
                            .map((watchedCard) => Animate(
                                effects: const [FadeEffect()],
                                child: watchedCard))
                            .toList(),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
