import 'package:catchmflixx/constants/styles/gradient.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/state/user/login/user.login.response.state.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:catchmflixx/widgets/player/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ContentCard extends ConsumerWidget {
  final String playLink;
  final String fullDetailsId;
  final String title;
  final String subTitle;
  final int? progress;
  final String poster;
  final int duration;

  const ContentCard(
      {super.key,
      required this.playLink,
      required this.duration,
      required this.poster,
      required this.fullDetailsId,
      required this.title,
      required this.subTitle,
      this.progress});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userLoginProvider);

    final progressPercent =
        (progress)! > 0 ? (progress ?? 0 / (duration * 60)) : 0.0;
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 300,
      height: 180,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white30.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(8)),
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
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: GestureDetector(
                  onTap: () {
                    if (user is LoadedUserLoginResponseState &&
                        user.userLoginResponse.isLoggedIn!) {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: PlayerScreen(
                            act: () {},
                            type: "",
                            title: title,
                            id: fullDetailsId,
                            details: subTitle,
                            playLink: playLink,
                          ),
                          type: PageTransitionType.rightToLeft,
                        ),
                      );
                    } else {
                      ToastShow.returnToast("Please login to view content");
                    }
                  },
                  child: const PhosphorIcon(
                    PhosphorIconsFill.play,
                    color: Colors.white,
                  )),
            ),
            progress != null
                ? Positioned(
                    bottom: 0,
                    child: Container(
                      height: 2,
                      width: (progress! / 100) * 150,
                      decoration: const BoxDecoration(color: Colors.white),
                    ),
                  )
                : const SizedBox(),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2)),
                  child: FractionallySizedBox(
                    alignment: Alignment.topLeft,
                    widthFactor: double.tryParse(progressPercent.toString()),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class CatchMFLixxColors {}
