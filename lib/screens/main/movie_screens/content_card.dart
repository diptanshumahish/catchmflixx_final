import 'package:catchmflixx/constants/styles/gradient.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/screens/payments/episode_renting_screen.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/state/user/login/user.login.response.state.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:catchmflixx/widgets/player/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ContentCard extends ConsumerWidget {
  final String playLink;
  final String fullDetailsId;
  final String title;
  final String subTitle;
  final int? progress;
  final String poster;
  final int duration;
  final bool isPaid;
  final bool userRented;
  final String episodeNumber;

  const ContentCard({
    super.key,
    required this.playLink,
    required this.episodeNumber,
    required this.userRented,
    required this.duration,
    required this.poster,
    required this.fullDetailsId,
    required this.title,
    required this.subTitle,
    required this.isPaid,
    this.progress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userLoginProvider);

    final progressPercent =
        (progress ?? 0) > 0 ? (progress ?? 0 / (duration * 60)) : 0.0;

    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 300,
      height: 180,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white30.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Image.network(
              width: 300,
              poster,
              fit: BoxFit.cover,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: const BoxDecoration(
                    gradient: CFGradient.topToBottomGradient),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Row(
                children: [
                  if (!isPaid)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'PAID',
                        style: TextStyles.smallSubText.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (userRented)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      margin: const EdgeInsets.only(left: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'RENTED',
                        style: TextStyles.smallSubText.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
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
                    subTitle,
                    style: TextStyles.smallSubText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      const PhosphorIcon(
                        PhosphorIconsRegular.hourglass,
                        color: Colors.grey,
                        size: 15,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${duration}m",
                        style: TextStyles.smallSubText,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  if (user is LoadedUserLoginResponseState &&
                      user.userLoginResponse.isLoggedIn!) {
                    if (isPaid || userRented) {
                      navigateToPage(context, "/player",
                          data: PlayerScreen(
                            act: () {},
                            type: "",
                            title: title,
                            id: fullDetailsId,
                            details: subTitle,
                            playLink: playLink,
                            seekTo: progress ?? 0,
                          ));
                    } else {
                      navigateToPage(context, "/episode-rent",
                          data: EpisodeRentingScreen(
                              act: () {},
                              episodeNumber: episodeNumber,
                              title: title,
                              img: poster,
                              id: fullDetailsId));
                    }
                  } else {
                    ToastShow.returnToast("Please login to view content");
                  }
                },
                child: const PhosphorIcon(
                  PhosphorIconsFill.play,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            if (progress != null && progress! > 0)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.topLeft,
                    widthFactor: progressPercent.toDouble(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
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
