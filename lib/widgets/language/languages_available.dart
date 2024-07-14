import 'package:catchmflixx/api/content/common.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/models/language/lang.model.dart';
import 'package:flutter/material.dart';

LanguageModel _lm = LanguageModel(success: false, data: {});

class LanguagesAvailable extends StatefulWidget {
  final String uuid;
  const LanguagesAvailable({super.key, required this.uuid});

  @override
  State<LanguagesAvailable> createState() => _LanguagesAvailableState();
}

class _LanguagesAvailableState extends State<LanguagesAvailable> {
  getData() async {
    ContentManager c = ContentManager();
    final data = await c.getLanguages(widget.uuid);
    if (data.success) {
      setState(() {
        _lm = data;
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(size.height / 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Content available in :",
              style: TextStyles.headingsForSections,
            ),
            Wrap(
              spacing: 8.0,
              children: _lm.data.keys.map((key) {
                return Text(
                  key,
                  style: TextStyles.formSubTitle,
                );
              }).toList(),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "To change the content language, go to settings and change app language",
              style: TextStyles.smallSubText,
            )
          ],
        ),
      ),
    );
  }
}
