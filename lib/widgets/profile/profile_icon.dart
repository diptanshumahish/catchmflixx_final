import 'package:cached_network_image/cached_network_image.dart';
import 'package:catchmflixx/api/user/profile/profile_api.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:pinput/pinput.dart';

class ProfileIcon extends ConsumerWidget {
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

  Future<void> _login({
    required BuildContext context,
    required WidgetRef ref,
    required String pin,
  }) async {
    final translation = AppLocalizations.of(context)!;
    final response = await ProfileApi().useProfileLogin(hash, pin);

    if (response != null && response.success == true) {
      await ref.read(currentProfileProvider.notifier).refresh();
      ref.watch(watchHistoryProvider.notifier).updateState();
      ref.watch(watchLaterProvider.notifier).updateState();
      ToastShow.returnToast("${translation.welcomeBack} $profileName");
      navigateToPage(context, "/base", isReplacement: true);
    } else {
      ToastShow.returnToast(translation.wrongPin);
    }
  }

  void _handleTap(BuildContext context, WidgetRef ref) {
    if (isProtected) {
      _showPinDialog(context, ref);
    } else {
      _login(context: context, ref: ref, pin: "");
    }
  }

  void _showPinDialog(BuildContext context, WidgetRef ref) {
    final translation = AppLocalizations.of(context)!;
    final height = MediaQuery.of(context).size.height;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "PIN Dialog",
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox(); // handled in transitionBuilder
      },
      transitionBuilder: (context, animation, _, __) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale:
                CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            child: AlertDialog(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                translation.enterYourPin,
                textAlign: TextAlign.center,
                style: height > 840
                    ? TextStyles.headingsForSections
                    : TextStyles.headingsForSectionsForSmallerScreens,
              ),
              content: _PinEntryContent(
                uniqueId: uniqueId,
                hash: hash,
                profileName: profileName,
                ref: ref,
                translation: translation,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final textStyle = height > 840
        ? TextStyles.headingsSecondaryMobile
        : TextStyles.headingsSecondaryMobileForSmallerScreens;

    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () => _handleTap(context, ref),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                imageUrl: avatar ?? '',
                height: 90,
                width: 90,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (_, __, ___) => const Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
                errorWidget: (_, __, ___) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profileName,
                    style: textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        isProtected
                            ? PhosphorIconsFill.lockSimple
                            : PhosphorIconsRegular.lockSimpleOpen,
                        size: 12,
                        color: Colors.white54,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        isAdult
                            ? AppLocalizations.of(context)!.adult
                            : AppLocalizations.of(context)!.kids,
                        style: TextStyles.smallSubText,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PinEntryContent extends StatefulWidget {
  final String uniqueId;
  final String hash;
  final String profileName;
  final WidgetRef ref;
  final AppLocalizations translation;

  const _PinEntryContent({
    required this.uniqueId,
    required this.hash,
    required this.profileName,
    required this.ref,
    required this.translation,
  });

  @override
  State<_PinEntryContent> createState() => _PinEntryContentState();
}

class _PinEntryContentState extends State<_PinEntryContent> {
  bool _isLoading = false;

  Future<void> _handlePinSubmit(String pin) async {
    setState(() => _isLoading = true);
    final res = await ProfileApi().useProfileLogin(widget.hash, pin);
    setState(() => _isLoading = false);

    if (res != null && res.success == true) {
      widget.ref.watch(watchHistoryProvider.notifier).updateState();
      widget.ref.watch(watchLaterProvider.notifier).updateState();
      ToastShow.returnToast(
          "${widget.translation.welcomeBack} ${widget.profileName}");
      Navigator.of(context).pop();
      navigateToPage(context, "/base", isReplacement: true);
    } else {
      Navigator.of(context).pop();
      ToastShow.returnToast(widget.translation.wrongPin);
    }
  }

  Future<void> _handleForgotPin() async {
    setState(() => _isLoading = true);
    final res = await ProfileApi().resetProfilePassword(widget.uniqueId);
    setState(() => _isLoading = false);

    if (res != null && res.success == true) {
      ToastShow.returnToast("Pin reset email sent, please check your email");
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),

          Pinput(
            length: 4,
            obscureText: true,
            autofocus: true,
            defaultPinTheme: PinTheme(
              width: 56,
              height: 64,
              textStyle: TextStyles.headingsSecondaryMobile,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.white38),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            focusedPinTheme: PinTheme(
              width: 56,
              height: 64,
              textStyle: TextStyles.headingsSecondaryMobile,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            submittedPinTheme: PinTheme(
              width: 56,
              height: 64,
              textStyle: TextStyles.headingsSecondaryMobile,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.white70),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onCompleted: _handlePinSubmit,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _isLoading ? null : _handleForgotPin,
            child: Text(
              widget.translation.forgotPassword,
              style: TextStyles.formSubTitle.copyWith(
                color: _isLoading ? Colors.grey : Colors.blueAccent,
              ),
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
        ],
      ),
    );
  }
}
