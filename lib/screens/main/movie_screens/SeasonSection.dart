import 'dart:io';

import 'package:catchmflixx/api/content/common.dart';
import 'package:catchmflixx/theme/typography.dart';
import 'package:catchmflixx/models/content/series/episodes.model.dart';
import 'package:catchmflixx/screens/main/movie_screens/content_card.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SeasonSection extends ConsumerStatefulWidget {
  final String sectionHeading;
  final String sectionDetails;
  final String uuid;
  final bool isFree;
  final String thumbnail;

  const SeasonSection({
    super.key,
    required this.sectionHeading,
    required this.uuid,
    required this.sectionDetails,
    required this.isFree,
    required this.thumbnail,
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
      EpisodesModel? data = await ct.getEpisodes(widget.uuid);
      if (data != null && data.success! && data.data!.episodes!.isNotEmpty) {
        ref
            .watch(firstEpProvider.notifier)
            .putAtFirstIndex(data.data!.episodes!.first.url.toString());
        ref
            .watch(firstEpProvider.notifier)
            .putAtSecondIndex(data.data!.episodes!.first.videoUuid.toString());
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

    final filteredEpisodes = Platform.isIOS
        ? _ep.data?.episodes
            ?.where((e) => (e.userRented == true || e.free == true))
            .toList()
        : _ep.data?.episodes;

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
                AppText(
                  widget.sectionHeading,
                  variant: AppTextVariant.sectionTitle,
                ),
                const SizedBox(height: 4),
                AppText(
                  widget.sectionDetails,
                  variant: AppTextVariant.bodySmall,
                  color: Colors.white70,
                  fontSize: 12,
                ),
                const SizedBox(height: 12),
                if (!widget.isFree)
                  _buildLockedContent(size)
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: filteredEpisodes
                              ?.map((e) => ContentCard(
                                    episodeNumber: e.epNumber.toString(),
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

  Widget _buildLockedContent(Size size) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: size.height * 0.18,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[700]!, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const AppText(
            'Premium Content',
            variant: AppTextVariant.sectionTitle,
          ),
          const SizedBox(height: 8),
          const AppText(
            'Unlock this season to watch all episodes',
            variant: AppTextVariant.body,
            color: Colors.white70,
            fontSize: 14,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _handlePayment();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const AppText(
              'Unlock Season',
              variant: AppTextVariant.subtitle,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _handlePayment() {
    // Navigate to season renting screen
    navigateToPage(
      context,
      "/season-renting",
      data: {
        'title': widget.sectionHeading,
        'seasonNumber':
            widget.sectionHeading.split(' ').last, // Extract season number
        'img': widget.thumbnail, // Use the actual season thumbnail
        'id': widget.uuid,
        'act': () {
          // Callback after successful payment
          getData(); // Refresh the data
        },
      },
    );
  }
}
