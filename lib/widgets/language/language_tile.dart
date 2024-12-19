import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_full_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangeLanguageTile extends ConsumerWidget {
  final Locale lang;
  final String languageName;
  const ChangeLanguageTile(this.lang, this.languageName, {super.key});

  void onLanguageChange(WidgetRef ref, Locale lang) {
    ref.read(languageProvider.notifier).switchLanguage(lang);
    ToastShow.returnToast("language changed successfully");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OffsetFullButton(
        content: languageName,
        fn: () {
          onLanguageChange(ref, lang);
          Navigator.pop(context);
        });
  }
}
