import 'package:cached_network_image/cached_network_image.dart';
// import 'package:catchmflixx/constants/styles/gradient.dart';
// import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:flutter/material.dart';

class ModifiedGenreCard extends StatelessWidget {
  final String fullDetailsId;
  final String title;
  final String subTitle;
  final String poster;
  const ModifiedGenreCard({
    super.key,
    required this.poster,
    required this.fullDetailsId,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: 210,
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0x1EFFFFFF)),
          borderRadius: BorderRadius.circular(5)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: poster,
              fit: BoxFit.cover,
              height: 210,
              width: size.width,
            ),
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(5),
            //   child: Container(
            //     decoration: const BoxDecoration(
            //         gradient: CFGradient.topToBottomGradient),
            //   ),
            // ),
            // SizedBox(
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       children: [
            //         Text(
            //           title,
            //           style: TextStyles.cardHeading,
            //           maxLines: 2,
            //           overflow: TextOverflow.ellipsis,
            //         ),
            //         Text(
            //           subTitle,
            //           style: TextStyles.smallSubText,
            //           maxLines: 1,
            //           overflow: TextOverflow.ellipsis,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
