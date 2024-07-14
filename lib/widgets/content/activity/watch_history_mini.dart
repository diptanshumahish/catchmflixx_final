import 'package:catchmflixx/api/user/user_activity/user.activity.dart';
import 'package:catchmflixx/api/user/user_activity/watch_history_list.model.dart';
import 'package:catchmflixx/widgets/common/cards/watched_card.dart';
import 'package:catchmflixx/widgets/common/section/section_component.dart';
import 'package:flutter/material.dart';

UserActivityHistory _wl = UserActivityHistory();

class WatchHistoryComponent extends StatefulWidget {
  const WatchHistoryComponent({super.key});

  @override
  State<WatchHistoryComponent> createState() => _WatchHistoryComponentState();
}

class _WatchHistoryComponentState extends State<WatchHistoryComponent> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    UserActivity ua = UserActivity();
    UserActivityHistory data = await ua.gatWatchHistory();
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
      sectionHeading: "Watch History",
      showMore: "",
      watchedCards: _wl.data!
          .map((e) => WatchedCard(
              duration: ((e.durationMinutes) ?? 0) * 60,
              type: e.contentType ?? "movie",
              playLink: e.video?.url ?? "",
              poster: e.video?.thumbnail ?? "",
              fullDetailsId: e.contentUuid ?? "",
              title: e.contentName ?? "",
              lastWatchedTime: e.lastWatchedTime ?? "",
              progress: int.parse(e.progressSeconds.toString()),
              subTitle: ""))
          .toList(),
    );
  }
}
