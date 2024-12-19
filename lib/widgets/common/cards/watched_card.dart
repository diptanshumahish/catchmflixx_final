import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/utils/datetime/format_watched_date.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:flutter/material.dart';

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
 
    final progressPercent = duration > 0 ? (progress / (duration)) : 0.0;
    return GestureDetector(
      onTap: () {
        navigateToPage(
          context,
          type == "movie" ? "/movie/$fullDetailsId" : "/series/$fullDetailsId",
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        width: 170,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              child: Image.network(
                poster,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
            ),
            const SizedBox(
              height: 1,
            ),
            Container(
              height: 4,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white24,
              ),
              child: FractionallySizedBox(
                alignment: Alignment.topLeft,
                widthFactor: progressPercent ,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFA7C7FF),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 1,
            ),
            SizedBox(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8))),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyles.cardHeading,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        type == "movie" ? "Movie" : "web Series",
                        style: TextStyles.smallSubText,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
