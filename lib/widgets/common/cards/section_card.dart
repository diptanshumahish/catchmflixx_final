import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  final String playLink;
  final String fullDetailsId;
  final String title;
  final String subTitle;
  final double? progress;
  final String poster;
  final String type;
  const SectionCard(
      {super.key,
      required this.playLink,
      required this.type,
      required this.poster,
      required this.fullDetailsId,
      required this.title,
      required this.subTitle,
      this.progress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateToPage(
          context,
          type == "movie" ? "/movie/$fullDetailsId" : "/series/$fullDetailsId",
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                poster,
                fit: BoxFit.cover,
                height: 240,
              ),
            ),
            progress != null
                ? Container(
                    height: 2,
                    width: (progress! / 100) * 150,
                    decoration: const BoxDecoration(color: Colors.yellow),
                  )
                : const SizedBox(),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
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
          ],
        ),
      ),
    );
  }
}
