import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/screens/payments/episode_renting_screen.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/state/user/login/user.login.response.state.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:catchmflixx/utils/vibrate/vibrations.dart';
import 'package:catchmflixx/widgets/player/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ContentCard extends ConsumerWidget {
  final String playLink;
  final String fullDetailsId;
  final String title;
  final String subTitle;
  final int progress;
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
    required this.progress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userLoginProvider);

    final progressPercent = (progress / (duration * 60));

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      child: GestureDetector(
        onTap: ()async  {
         await  vibrateTap();
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
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 160,
                  height: 90,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white30.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      poster,
                      width: 160,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                /// add a background black filter
                Positioned.fill(
                  child: Container(
                    color: Colors.black26,
                  ),
                ),

                const Positioned.fill(
                  child: Center(
                    child: Icon(
                      PhosphorIconsFill.playCircle,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),

                if (progress > 0)
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
                              )))),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        if (!isPaid)
                          const Icon(
                            PhosphorIconsFill.crown,
                            color: Colors.orangeAccent,
                            size: 14,
                          ),
                        if (userRented) const SizedBox(width: 5),
                        if (userRented)
                          const Icon(
                            PhosphorIconsFill.checkCircle,
                            color: Colors.green,
                            size: 14,
                          ),
                      ],
                    ),
                    if (!isPaid || userRented) const SizedBox(height: 5),
                    Text(
                      title,
                      style: TextStyles.cardHeading,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subTitle,
                      style: TextStyles.smallSubText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          PhosphorIconsRegular.clock,
                          color: Colors.white,
                          size: 12,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '$duration mins',
                          style: TextStyles.textButton,
                        ),
                      ],
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
