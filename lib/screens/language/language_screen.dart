import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/widgets/common/flex/flex_items.dart';
import 'package:catchmflixx/widgets/language/language_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
            backgroundColor: Colors.black,
            title: Text(
              translation.settingsLangChose,
              style: TextStyles.headingsForSections,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translation.choseDesiredLanguage,
                    style: TextStyles.formSubTitle,
                  )
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: FlexItems(widgetList: [
                  ChangeLanguageTile(Locale("en"), "English"),
                  ChangeLanguageTile(Locale("ta"), "தமிழ்"),
                  ChangeLanguageTile(Locale("ml"), "മലയാളം"),
                  ChangeLanguageTile(Locale("te"), "తెలుగు"),
                  ChangeLanguageTile(Locale("kn"), "ಕನ್ನಡ"),
                  ChangeLanguageTile(Locale("hi"), "हिंदी")
                ], space: 10)),
          ),
        ],
      ),
    );
  }
}
