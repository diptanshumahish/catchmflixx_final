import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/widgets/common/cards/watched_card.dart';
import 'package:catchmflixx/widgets/common/section/section_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WatchHistoryComponent extends ConsumerStatefulWidget {
  const WatchHistoryComponent({super.key});

  @override
  ConsumerState<WatchHistoryComponent> createState() =>
      _WatchHistoryComponentState();
}

class _WatchHistoryComponentState extends ConsumerState<WatchHistoryComponent> {
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(watchHistoryProvider);
    if (data.success == false || data.success == null) {
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
    if (data.success == true && data.data!.isEmpty) {
      return const SliverToBoxAdapter();
    }
    return Section(
      sectionDetails: "Check out what you have been watching so far",
      sectionHeading: "Watch History",
      showMore: "",
      compact: true,
      hideHeader: true,
      watchedCards: data.data!
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
