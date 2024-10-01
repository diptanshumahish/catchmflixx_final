import 'package:cached_network_image/cached_network_image.dart';
import 'package:catchmflixx/api/user/profile/profile_api.dart';
import 'package:catchmflixx/api/user/profile/profile_response_model.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProfileIcon extends ConsumerWidget {
  final String uniqueId;
  final String? avatar;
  final String profileName;
  final bool isProtected;
  final bool isAdult;
  final String hash;
  const ProfileIcon(
      {super.key,
      required this.uniqueId,
      required this.isAdult,
      required this.isProtected,
      required this.hash,
      required this.avatar,
      required this.profileName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translation = AppLocalizations.of(context)!;

    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () async {
        ProfileApi pro = ProfileApi();
        if (isProtected == false) {
          var res = await pro.useProfileLogin(hash, "");
          if (res.success!) {
            ref.watch(watchHistoryProvider.notifier).updateState();
            ref.watch(watchLaterProvider.notifier).updateState();

            ToastShow.returnToast("${translation.welcomeBack} $profileName");
            navigateToPage(
              context,
              "/base",
              isReplacement: true,
            );
          } else {
            ToastShow.returnToast(translation.wrongPin);
          }
        } else {
          showDialog(
              context: context,
              builder: (BuildContext dialogContext) => AlertDialog(
                    backgroundColor: Colors.black,
                    title: Text(
                      translation.enterYourPin,
                      style: MediaQuery.of(context).size.height > 840
                          ? TextStyles.headingsForSections
                          : TextStyles.headingsForSectionsForSmallerScreens,
                      textAlign: TextAlign.center,
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        OtpTextField(
                          showFieldAsBox: true,
                          obscureText: true,
                          clearText: true,
                          autoFocus: true,
                          onSubmit: (String val) async {
                            if (val.length == 4) {
                              ProfileLoginResponse res =
                                  await pro.useProfileLogin(hash, val);

                              if (res.success!) {
                                ref
                                    .watch(watchHistoryProvider.notifier)
                                    .updateState();
                                ref
                                    .watch(watchLaterProvider.notifier)
                                    .updateState();
                                Navigator.pop(dialogContext);
                                ToastShow.returnToast(translation.welcomeBack);
                                navigateToPage(context, "/base",
                                    isReplacement: true);
                              } else {
                                ToastShow.returnToast(translation.wrongPin);
                              }
                            }
                          },
                          styles: const [
                            TextStyles.headingsSecondaryMobile,
                            TextStyles.headingsSecondaryMobile,
                            TextStyles.headingsSecondaryMobile,
                            TextStyles.headingsSecondaryMobile
                          ],
                          numberOfFields: 4,
                          borderColor: Colors.black38,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CupertinoButton(
                            child: Text(
                              translation.forgotPassword,
                              style: TextStyles.formSubTitle,
                            ),
                            onPressed: () async {
                              ProfileApi p = ProfileApi();
                              final data =
                                  await p.resetProfilePassword(uniqueId);
                              if (data.success == true) {
                                ToastShow.returnToast(
                                    "pin reset email sent, please check your email");
                              }
                            }),
                      ],
                    ),
                  ));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedNetworkImage(
                  imageUrl: avatar!,
                  height: 90,
                  width: 90,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CupertinoActivityIndicator(
                      color: Colors.white,
                      radius: 8,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profileName,
                  style: MediaQuery.of(context).size.height > 840
                      ? TextStyles.headingsSecondaryMobile
                      : TextStyles.headingsSecondaryMobileForSmallerScreens,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isProtected
                        ? const Icon(
                            PhosphorIconsFill.lockSimple,
                            color: Colors.white54,
                            size: 12,
                          )
                        : const Icon(
                            PhosphorIconsRegular.lockSimpleOpen,
                            color: Colors.white54,
                            size: 12,
                          ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      isAdult ? translation.adult : translation.kids,
                      style: TextStyles.smallSubText,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
