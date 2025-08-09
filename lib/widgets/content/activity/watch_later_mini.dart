import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/widgets/common/cards/section_card.dart';
import 'package:catchmflixx/widgets/common/section/section_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WatchLaterComponent extends ConsumerStatefulWidget {
  const WatchLaterComponent({super.key});

  @override
  ConsumerState<WatchLaterComponent> createState() =>
      _WatchLaterComponentState();
}

class _WatchLaterComponentState extends ConsumerState<WatchLaterComponent> {
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(watchLaterProvider);
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
      sectionHeading: "Added to watch Later",
      showMore: "",
      compact: true,
      hideHeader: true,
      sectionCards: data.data!
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
