import 'package:catchmflixx/api/content/common.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/models/content/series/episodes.model.dart';
import 'package:catchmflixx/screens/main/movie_screens/content_card.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SeasonSection extends ConsumerStatefulWidget {
  final String sectionHeading;
  final String sectionDetails;
  final String uuid;

  const SeasonSection({
    super.key,
    required this.sectionHeading,
    required this.uuid,
    required this.sectionDetails,
  });

  @override
  ConsumerState<SeasonSection> createState() => _SeasonSectionState();
}

class _SeasonSectionState extends ConsumerState<SeasonSection> {
  EpisodesModel _ep = EpisodesModel();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      ContentManager ct = ContentManager();
      EpisodesModel data = await ct.getEpisodes(widget.uuid);
      if (data.success!&&data.data!.episodes!.isNotEmpty) {
      ref.watch(firstEpProvider.notifier).putAtFirstIndex(data.data!.episodes!.first.url.toString());
      ref.watch(firstEpProvider.notifier).putAtSecondIndex(data.data!.episodes!.first.videoUuid.toString());
        setState(() {
          _ep = data;
        });
      }
    } catch (e) {
      ToastShow.returnToast(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05, vertical: size.height * 0.02),
      child: isLoading
          ? SizedBox(
              height: size.height / 3,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.sectionHeading,
                  style: TextStyles.headingsForSections.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.sectionDetails,
                  style: TextStyles.smallSubText.copyWith(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: _ep.data?.episodes!
                            .map((e) => ContentCard(
                              episodeNumber: e.epNumber.toString() ?? "0",
                              isPaid: e.free ?? false,
                              userRented: e.userRented ?? false,
                              key: Key(e.videoUuid ?? ""),
                              playLink: e.url ?? "",
                              duration: e.durationMinutes ?? 0,
                              poster: e.thumbnail ?? "",
                              fullDetailsId: e.videoUuid ?? "",
                              title: e.subTitle ?? "",
                              subTitle: e.subDescription ?? "",
                              progress: e.progress ?? 0,
                            ))
                            .toList() ??
                        [],
                  ),
                ),
              ],
            ),
    );
  }
}
