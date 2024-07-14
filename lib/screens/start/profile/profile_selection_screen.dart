import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/models/profiles/profile.model.dart';
import 'package:catchmflixx/widgets/profile/profile_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilesSelection extends ConsumerWidget {
  final ProfilesList profiles;
  const ProfilesSelection(this.profiles, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final translation = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(size.height / 40),
          child: SizedBox(
            height: size.height,
            child: Stack(
              children: [
                Positioned(
                    left: 0,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translation.whosWatching,
                          style: size.height > 840
                              ? TextStyles.headingsSecondaryMobile
                              : TextStyles
                                  .headingsSecondaryMobileForSmallerScreens,
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          translation.chooseProfile,
                          style: TextStyles.smallSubText,
                        )
                      ],
                    )),
                Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: profiles.data!.map((e) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 9.0),
                          child: ProfileIcon(
                              hash: e.hash ?? "",
                              isProtected: e.is_protected ?? false,
                              uniqueId: e.uuid ?? "",
                              isAdult: e.profile_type == "Adult" ? true : false,
                              avatar: e.avatar,
                              profileName: e.name ?? ""),
                        );
                      }).toList()),
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Text(
                      translation.canAddMore,
                      style: TextStyles.detailsMobile,
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
