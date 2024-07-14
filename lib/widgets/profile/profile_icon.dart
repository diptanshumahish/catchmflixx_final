import 'package:cached_network_image/cached_network_image.dart';
import 'package:catchmflixx/api/user/profile/profile_api.dart';
import 'package:catchmflixx/api/user/profile/profile_response_model.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/screens/main/home_main.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProfileIcon extends StatelessWidget {
  final String uniqueId;
  final String? avatar;
  final String profileName;
  final bool isProtected;
  final bool isAdult;
  final String hash;

  const ProfileIcon({
    super.key,
    required this.uniqueId,
    required this.isAdult,
    required this.isProtected,
    required this.hash,
    required this.avatar,
    required this.profileName,
  });

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _handleProfileTap(context, translation),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            _buildProfileImage(),
            const SizedBox(width: 20),
            _buildProfileInfo(context, translation),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(90),
      child: CachedNetworkImage(
        imageUrl: avatar ?? '',
        height: 90,
        width: 90,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            const Padding(
          padding: EdgeInsets.all(20.0),
          child: CupertinoActivityIndicator(
            color: Colors.white,
            radius: 8,
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context, AppLocalizations translation) {
    return Column(
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
          children: [
            Icon(
              isProtected
                  ? PhosphorIconsFill.lockSimple
                  : PhosphorIconsRegular.lockSimpleOpen,
              color: Colors.white54,
              size: 12,
            ),
            const SizedBox(width: 5),
            Text(
              isAdult ? translation.adult : translation.kids,
              style: TextStyles.smallSubText,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _handleProfileTap(
      BuildContext context, AppLocalizations translation) async {
    if (isProtected) {
      _showPinDialog(context, translation);
    } else {
      await _loginProfile(context, translation, "");
    }
  }

  Future<void> _loginProfile(
      BuildContext context, AppLocalizations translation, String pin) async {
    final ProfileApi profileApi = ProfileApi();
    final res = await profileApi.useProfileLogin(hash, pin);

    if (res.success!) {
      ToastShow.returnToast("${translation.welcomeBack} $profileName");
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          child: const BaseMain(),
          type: PageTransitionType.rightToLeft,
        ),
        (route) => false,
      );
    } else {
      ToastShow.returnToast(translation.wrongPin);
    }
  }

  void _showPinDialog(BuildContext context, AppLocalizations translation) {
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
        content: _buildPinInput(context, translation),
      ),
    );
  }

  Widget _buildPinInput(BuildContext context, AppLocalizations translation) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 5),
        OtpTextField(
          keyboardType: TextInputType.number,
          showFieldAsBox: true,
          obscureText: true,
          clearText: true,
          autoFocus: true,
          onSubmit: (String pin) async {
            if (pin.length == 4) {
              await _loginProfile(context, translation, pin);
              Navigator.pop(context);
            }
          },
          styles: const [
            TextStyles.headingsSecondaryMobile,
            TextStyles.headingsSecondaryMobile,
            TextStyles.headingsSecondaryMobile,
            TextStyles.headingsSecondaryMobile,
          ],
          numberOfFields: 4,
          borderColor: Colors.black38,
        ),
        const SizedBox(height: 5),
        CupertinoButton(
          child: Text(
            translation.forgotPassword,
            style: TextStyles.formSubTitle,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
