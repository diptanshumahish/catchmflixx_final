import 'package:catchmflixx/api/content/common.dart';
import 'package:catchmflixx/models/content/search.list.model.dart';
import 'package:catchmflixx/widgets/common/cards/section_card.dart';
import 'package:catchmflixx/widgets/common/section/section_component.dart';
import 'package:flutter/material.dart';

ContentList _cList = ContentList();

class HomeFirst extends StatefulWidget {
  const HomeFirst({super.key});

  @override
  State<HomeFirst> createState() => _HomeFirstState();
}

class _HomeFirstState extends State<HomeFirst> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    ContentManager ct = ContentManager();
    ContentList data = await ct.searchContent("");
    if (data.results!.success!) {
      setState(() {
        _cList = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cList.results?.success == false || _cList.results == null) {
      return SliverToBoxAdapter(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ),
      );
    }
    return Section(
      sectionDetails: "The best content picked just for you",
      sectionHeading: "Catch M Flixx editorial",
      showMore: "",
      sectionCards: _cList.results?.data!
          .map((e) => SectionCard(
              type: e.type ?? "movie",
              playLink: e.uuid ?? "",
              poster: e.thumbnail ?? "",
              fullDetailsId: e.uuid ?? "",
              title: e.metaData!.title ?? "",
              subTitle: e.metaData!.description ?? ""))
          .toList(),
    );
  }
}
