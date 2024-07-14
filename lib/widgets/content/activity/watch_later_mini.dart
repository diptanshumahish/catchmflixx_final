import 'package:catchmflixx/api/user/profile/profile_api.dart';
import 'package:catchmflixx/api/user/user_activity/watch_later_list.dart';
import 'package:catchmflixx/widgets/common/cards/section_card.dart';
import 'package:catchmflixx/widgets/common/section/section_component.dart';
import 'package:flutter/material.dart';

WatchLaterList _wl = WatchLaterList();

class WatchLaterComponent extends StatefulWidget {
  const WatchLaterComponent({super.key});

  @override
  State<WatchLaterComponent> createState() => _WatchLaterComponentState();
}

class _WatchLaterComponentState extends State<WatchLaterComponent> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    ProfileApi p = ProfileApi();
    WatchLaterList data = await p.gatWatchLater();
    if (data.success!) {
      setState(() {
        _wl = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_wl.success == false || _wl.success == null) {
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
    if (_wl.success == true && _wl.data!.isEmpty) {
      return const SliverToBoxAdapter();
    }
    return Section(
      sectionDetails: "Check out what you have been watching so far",
      sectionHeading: "Added to watch Later",
      showMore: "",
      sectionCards: _wl.data!
          .map((e) => SectionCard(
              type: e.type ?? "movie",
              playLink: e.uuid ?? "",
              poster: e.thumbnail ?? "",
              fullDetailsId: e.uuid ?? "",
              title: e.metaData?.title ?? "",
              subTitle: e.metaData?.description ?? ""))
          .toList(),
    );
  }
}
