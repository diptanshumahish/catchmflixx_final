import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/widgets/common/cards/section_card.dart';
import 'package:catchmflixx/widgets/common/cards/watched_card.dart';
import 'package:catchmflixx/utils/responsive/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Section extends StatefulWidget {
  final String sectionHeading;
  final String sectionDetails;
  final List<SectionCard>? sectionCards;
  final List<WatchedCard>? watchedCards;
  final String showMore;
  final bool compact;
  final bool hideHeader;
  const Section(
      {super.key,
      required this.sectionHeading,
      required this.showMore,
      this.watchedCards,
      required this.sectionDetails,
      this.sectionCards,
      this.compact = false,
      this.hideHeader = false});

  @override
  _SectionState createState() => _SectionState();
}

class _SectionState extends State<Section> {
  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size; // not needed for compact adjustments

    return SliverToBoxAdapter(
      child: Container(
        margin: ResponsiveUtils.getResponsiveEdgeInsets(
          context,
          basePadding: EdgeInsets.symmetric(
            horizontal: widget.compact ? 20 : 20,
            vertical: widget.compact ? 6 : 12,
          ),
          smallScreenPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: widget.compact ? 6 : 10,
          ),
          largeScreenPadding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: widget.compact ? 8 : 14,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!widget.hideHeader)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: widget.compact ? 8 : 16,
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
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.sectionHeading,
                            style: TextStyles.getResponsiveSectionHeading(context).copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: widget.compact ? 16 : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        widget.sectionDetails,
                        style: TextStyles.getResponsiveSmallSubText(context).copyWith(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            // Enhanced content area with better spacing and animations
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.compact ? 10 : 12),
                color: Colors.white.withOpacity(widget.compact ? 0.0 : 0.02),
                border: widget.compact
                    ? null
                    : Border.all(
                        color: Colors.white.withOpacity(0.05),
                        width: 1,
                      ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.compact ? 10 : 12),
                child: Column(
                  children: [
                    // Section Cards
                    if (widget.sectionCards != null)
                      Container(
                        padding: EdgeInsets.symmetric(vertical: widget.compact ? 8 : 16),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: widget.sectionCards!
                                .asMap()
                                .entries
                                .map((entry) {
                              final index = entry.key;
                              final sectionCard = entry.value;
                              return Animate(
                                effects: [
                                  FadeEffect(
                                    delay: Duration(milliseconds: 100 * index),
                                  ),
                                  SlideEffect(
                                    begin: const Offset(0.3, 0),
                                    delay: Duration(milliseconds: 100 * index),
                                  ),
                                ],
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: index == 0 ? (widget.compact ? 8 : 16) : (widget.compact ? 6 : 8),
                                    right: index == widget.sectionCards!.length - 1 ? (widget.compact ? 8 : 16) : 0,
                                  ),
                                  child: sectionCard,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    
                    // Watched Cards
                    if (widget.watchedCards != null)
                      Container(
                        padding: EdgeInsets.symmetric(vertical: widget.compact ? 8 : 16),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: widget.watchedCards!
                                .asMap()
                                .entries
                                .map((entry) {
                              final index = entry.key;
                              final watchedCard = entry.value;
                              return Animate(
                                effects: [
                                  FadeEffect(
                                    delay: Duration(milliseconds: 100 * index),
                                  ),
                                  SlideEffect(
                                    begin: const Offset(0.3, 0),
                                    delay: Duration(milliseconds: 100 * index),
                                  ),
                                ],
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: index == 0 ? (widget.compact ? 8 : 16) : (widget.compact ? 6 : 8),
                                    right: index == widget.watchedCards!.length - 1 ? (widget.compact ? 8 : 16) : 0,
                                  ),
                                  child: watchedCard,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
