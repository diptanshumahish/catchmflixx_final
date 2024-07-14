import 'package:cached_network_image/cached_network_image.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/screens/start/check_logged_in.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_full_button.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final List<Map<String, String>> genreList = [
  {
    "name": "Horror",
    "image":
        "https://img.playbook.com/Axh_gEkgZbsvB1VDuXm4GNvbjXXu2RUUqwToXJEJ8ZQ/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzM5NTk3ODYx/LWQ1MzItNDZmMC1i/ZDhmLTQ2NjRiYjcz/NjZmMQ",
  },
  {
    "name": "Romance",
    "image":
        "https://img.playbook.com/Axh_gEkgZbsvB1VDuXm4GNvbjXXu2RUUqwToXJEJ8ZQ/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzM5NTk3ODYx/LWQ1MzItNDZmMC1i/ZDhmLTQ2NjRiYjcz/NjZmMQ",
  },
  {
    "name": "Action",
    "image":
        "https://img.playbook.com/Axh_gEkgZbsvB1VDuXm4GNvbjXXu2RUUqwToXJEJ8ZQ/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzM5NTk3ODYx/LWQ1MzItNDZmMC1i/ZDhmLTQ2NjRiYjcz/NjZmMQ",
  },
  {
    "name": "Thriller",
    "image":
        "https://img.playbook.com/Axh_gEkgZbsvB1VDuXm4GNvbjXXu2RUUqwToXJEJ8ZQ/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzM5NTk3ODYx/LWQ1MzItNDZmMC1i/ZDhmLTQ2NjRiYjcz/NjZmMQ",
  },
  {
    "name": "Drama",
    "image":
        "https://img.playbook.com/Axh_gEkgZbsvB1VDuXm4GNvbjXXu2RUUqwToXJEJ8ZQ/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzM5NTk3ODYx/LWQ1MzItNDZmMC1i/ZDhmLTQ2NjRiYjcz/NjZmMQ",
  },
  {
    "name": "Comedy",
    "image":
        "https://img.playbook.com/Axh_gEkgZbsvB1VDuXm4GNvbjXXu2RUUqwToXJEJ8ZQ/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzM5NTk3ODYx/LWQ1MzItNDZmMC1i/ZDhmLTQ2NjRiYjcz/NjZmMQ",
  },
  {
    "name": "Sci-Fi",
    "image":
        "https://img.playbook.com/Axh_gEkgZbsvB1VDuXm4GNvbjXXu2RUUqwToXJEJ8ZQ/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzM5NTk3ODYx/LWQ1MzItNDZmMC1i/ZDhmLTQ2NjRiYjcz/NjZmMQ",
  },
  {
    "name": "Biography",
    "image":
        "https://img.playbook.com/Axh_gEkgZbsvB1VDuXm4GNvbjXXu2RUUqwToXJEJ8ZQ/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzM5NTk3ODYx/LWQ1MzItNDZmMC1i/ZDhmLTQ2NjRiYjcz/NjZmMQ",
  },
  {
    "name": "Real",
    "image":
        "https://img.playbook.com/Axh_gEkgZbsvB1VDuXm4GNvbjXXu2RUUqwToXJEJ8ZQ/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzM5NTk3ODYx/LWQ1MzItNDZmMC1i/ZDhmLTQ2NjRiYjcz/NjZmMQ",
  },
];

class ChooseGenresScreen extends StatefulWidget {
  const ChooseGenresScreen({super.key});

  @override
  State<ChooseGenresScreen> createState() => _ChooseGenresScreenState();
}

class _ChooseGenresScreenState extends State<ChooseGenresScreen> {
  List<int> sel = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final translation = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(size.height / 40),
          child: OffsetFullButton(
              content: "Done",
              icon: Icons.flare_rounded,
              fn: () => {
                    Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                            child: const CheckLoggedIn(),
                            type: PageTransitionType.rightToLeft,
                            isIos: true),
                        (r) => false)
                  }),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(size.height / 40),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SafeArea(
                child: SizedBox(
                  child: Text(
                    translation.choseFavGenre,
                    style: size.height > 840
                        ? TextStyles.headingsSecondaryMobile
                        : TextStyles.headingsSecondaryMobileForSmallerScreens,
                  ),
                ),
              ),
            ),
            SliverGrid.builder(
                itemCount: genreList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (BuildContext ctx, int index) {
                  return GestureDetector(
                    onTap: () => {
                      setState(() {
                        sel.contains(index)
                            ? sel.remove(index)
                            : sel.add(index);
                      })
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: sel.contains(index)
                              ? Colors.white24
                              : Colors.white10,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: CachedNetworkImageProvider(
                                    genreList[index]["image"].toString()),
                              ),
                              Text(
                                genreList[index]["name"].toString(),
                                style: TextStyles.formSubTitle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
