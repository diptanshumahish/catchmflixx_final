import 'package:catchmflixx/constants/styles/gradient.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/widgets/player/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class TrailerCard extends StatelessWidget {
  final String title;
  final String playId;

  final String poster;
  const TrailerCard({
    super.key,
    required this.poster,
    required this.playId,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                child: PlayerScreen(
                  act: () {},
                  type: "Trailer",
                  playLink: playId,
                  title: title,
                  details: "TRAILER",
                  id: playId,
                ),
                type: PageTransitionType.leftToRight));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        width: 300,
        height: 190,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white30),
            borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Image.network(
                poster,
                fit: BoxFit.cover,
                height: 190,
                width: double.infinity,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: CFGradient.topToBottomGradient),
                ),
              ),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        title,
                        style: TextStyles.cardHeading,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
