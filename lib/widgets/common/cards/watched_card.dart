import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/theme/typography.dart';
import 'package:catchmflixx/utils/datetime/format_watched_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class WatchedCard extends StatelessWidget {
  final String playLink;
  final String fullDetailsId;
  final String title;
  final String subTitle;
  final int progress;
  final String poster;
  final String type;
  final String lastWatchedTime;
  final int duration;
  const WatchedCard(
      {super.key,
      required this.duration,
      required this.playLink,
      required this.type,
      required this.poster,
      required this.fullDetailsId,
      required this.title,
      required this.lastWatchedTime,
      required this.subTitle,
      required this.progress});

  @override
  Widget build(BuildContext context) {
    final clampedProgress = duration > 0 ? (progress / duration).clamp(0.0, 1.0) : 0.0;

    String? formattedWatched;
    if (lastWatchedTime.isNotEmpty) {
      try {
        final parsed = DateTime.parse(lastWatchedTime).toLocal();
        formattedWatched = formatWatchedDate(parsed);
      } catch (_) {
        formattedWatched = null;
      }
    }

    return SizedBox(
      width: 156,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            HapticFeedback.selectionClick();
            navigateToPage(
              context,
              type == "movie" ? "/movie/$fullDetailsId" : "/series/$fullDetailsId",
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    // Poster
                    AspectRatio(
                      aspectRatio: 2/3,
                      child: Image.network(
                        poster,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(color: Colors.white12);
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.white10,
                            child: const Center(
                              child: Icon(Icons.broken_image, color: Colors.white54),
                            ),
                          );
                        },
                      ),
                    ),

                    // Bottom gradient
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Type pill
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.white12, width: 1),
                        ),
                        child: AppText(
                          type.toLowerCase() == 'movie' ? 'Movie' : 'Series',
                          variant: AppTextVariant.caption,
                          color: Colors.white,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ),

                    // Play/resume button
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24, width: 1),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(PhosphorIconsFill.play, color: Colors.white, size: 16),
                      ),
                    ),

                    // Progress bar overlay
                    Positioned(
                      left: 8,
                      right: 8,
                      bottom: 8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          height: 4,
                          color: Colors.white.withOpacity(0.2),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: clampedProgress,
                              child: Container(
                                color: const Color(0xFFA7C7FF),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              AppText(
                title,
                variant: AppTextVariant.body,
                color: Colors.white,
                weight: FontWeight.w700,
                maxLines: 2,
              ),
              const SizedBox(height: 2),
              AppText(
                formattedWatched ?? (type.toLowerCase() == 'movie' ? 'Movie' : 'Series'),
                variant: AppTextVariant.caption,
                color: Colors.white70,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
