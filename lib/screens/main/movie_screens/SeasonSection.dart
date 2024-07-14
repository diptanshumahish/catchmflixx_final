import 'package:catchmflixx/api/content/common.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/models/content/series/episodes.model.dart';
import 'package:catchmflixx/screens/main/movie_screens/content_card.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:flutter/material.dart';

class SeasonSection extends StatefulWidget {
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
  State<SeasonSection> createState() => _SeasonSectionState();
}

class _SeasonSectionState extends State<SeasonSection> {
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
      if (data.success!) {
        setState(() {
          _ep = data;
        });
      } else {}
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
      padding: EdgeInsets.all(size.height / 40),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        widget.sectionHeading,
                        style: TextStyles.headingsForSections,
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.sectionDetails,
                  style: TextStyles.smallSubText,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: _ep.data?.episodes!
                              .map((e) => ContentCard(
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
                )
              ],
            ),
    );
  }
}
