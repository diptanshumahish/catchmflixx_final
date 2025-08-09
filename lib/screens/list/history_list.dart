import 'package:catchmflixx/api/user/user_activity/user.activity.dart';
import 'package:catchmflixx/api/user/user_activity/watch_history_list.model.dart';
import 'package:catchmflixx/constants/images.dart';
import 'package:catchmflixx/utils/datetime/format_watched_date.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:flutter/material.dart';
import 'package:catchmflixx/theme/typography.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';

UserActivityHistory _wl = UserActivityHistory();

class HistoryListWidget extends StatefulWidget {
  const HistoryListWidget({super.key});

  @override
  State<HistoryListWidget> createState() => _HistoryListWidgetState();
}

class _HistoryListWidgetState extends State<HistoryListWidget> {
  bool _isLoading = true;

  getData() async {
    UserActivity u = UserActivity();
    final data = await u.getWatchHistory();
    if (data != null && data.success!) {
      setState(() {
        _wl = data;
        _isLoading = false;
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
    // final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: _isLoading
          ? Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1A1A1A), Color(0xFF0A0A0A)],
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 20),
                    AppText(
                      "Loading your history...",
                      variant: AppTextVariant.subtitle,
                      color: Colors.white70,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            )
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1A1A1A), Color(0xFF0A0A0A)],
                ),
              ),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    expandedHeight: 120,
                    floating: false,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const PhosphorIcon(
                          PhosphorIconsRegular.arrowLeft,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      title: const Text(
                        "Watch History",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      background: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: AppText(
                        "Your viewing history - track your progress and continue where you left off",
                        variant: AppTextVariant.subtitle,
                        color: Colors.white70,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  if (_wl.data?.isEmpty == true)
                    SliverToBoxAdapter(
                      child: Animate(
                        effects: const [FadeEffect(duration: Duration(milliseconds: 800))],
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                CatchMFlixxImages.nope,
                                height: 120,
                                width: 120,
                              ),
                              const SizedBox(height: 30),
                              const AppText(
                                "No Watch History",
                                variant: AppTextVariant.headline,
                              ),
                              const SizedBox(height: 12),
                              const AppText(
                                "Start watching content to see your history here",
                                variant: AppTextVariant.subtitle,
                                color: Colors.white60,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: AppText(
                                "${_wl.data?.length ?? 0} items",
                                variant: AppTextVariant.caption,
                                color: Colors.red,
                                weight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SliverList.builder(
                    itemBuilder: (context, idx) {
                      final item = _wl.data?[idx];
                      final progress = (item?.progressSeconds ?? 0) /
                          ((item?.durationMinutes ?? 1) * 60);

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Animate(
                          effects: [
                            FadeEffect(
                              delay: Duration(milliseconds: idx * 100),
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeOutCubic,
                            ),
                            SlideEffect(
                              delay: Duration(milliseconds: idx * 100),
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeOutCubic,
                              begin: const Offset(0, 0.3),
                              end: Offset.zero,
                            ),
                          ],
                          child: GestureDetector(
                            onTap: () {
                              navigateToPage(
                                context,
                                item?.contentType == "movie"
                                    ? "/movie/${item?.contentUuid ?? ''}"
                                    : "/series/${item?.contentUuid ?? ''}",
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    // Number indicator
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.red.withOpacity(0.8),
                                            Colors.red.withOpacity(0.6),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: AppText(
                                          '${idx + 1}',
                                          variant: AppTextVariant.subtitle,
                                          weight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    // Thumbnail and content
                                    Expanded(
                                      child: Row(
                                        children: [
                                          // Thumbnail
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Stack(
                                              children: [
                                                Container(
                                                  width: 80,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: item?.video?.thumbnail != null
                                                      ? Image.network(
                                                          filterQuality: FilterQuality.high,
                                                          item!.video!.thumbnail!,
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (context, error, stackTrace) {
                                                            return Container(
                                                              width: 80,
                                                              height: 100,
                                                              decoration: BoxDecoration(
                                                                color: Colors.grey.withOpacity(0.3),
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                              child: const Icon(
                                                                Icons.movie,
                                                                color: Colors.white54,
                                                                size: 30,
                                                              ),
                                                            );
                                                          },
                                                        )
                                                      : Container(
                                                          width: 80,
                                                          height: 100,
                                                          decoration: BoxDecoration(
                                                            color: Colors.grey.withOpacity(0.3),
                                                            borderRadius: BorderRadius.circular(12),
                                                          ),
                                                          child: const Icon(
                                                            Icons.movie,
                                                            color: Colors.white54,
                                                            size: 30,
                                                          ),
                                                        ),
                                                ),
                                                Positioned.fill(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(12),
                                                      gradient: LinearGradient(
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        colors: [
                                                          Colors.transparent,
                                                          Colors.black.withOpacity(0.7),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const Positioned.fill(
                                                  child: Center(
                                                    child: PhosphorIcon(
                                                      PhosphorIconsDuotone.play,
                                                      duotoneSecondaryColor: Colors.white,
                                                      color: Colors.white,
                                                      duotoneSecondaryOpacity: 0.5,
                                                      size: 24,
                                                    ),
                                                  ),
                                                ),
                                                // Progress bar
                                                Positioned(
                                                  bottom: 0,
                                                  left: 0,
                                                  right: 0,
                                                  child: Container(
                                                    height: 3,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black.withOpacity(0.5),
                                                    ),
                                                    child: FractionallySizedBox(
                                                      alignment: Alignment.topLeft,
                                                      widthFactor: progress.clamp(0.0, 1.0),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          gradient: const LinearGradient(
                                                            colors: [
                                                              Colors.red,
                                                              Colors.orange
                                                            ],
                                                          ),
                                                          borderRadius: BorderRadius.circular(2),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          // Content
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // Type badge
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: item?.contentType == "web_series"
                                                        ? Colors.blue.withOpacity(0.2)
                                                        : Colors.orange.withOpacity(0.2),
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(
                                                      color: item?.contentType == "web_series"
                                                          ? Colors.blue.withOpacity(0.3)
                                                          : Colors.orange.withOpacity(0.3),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: AppText(
                                                    item?.contentType == "web_series" ? "Series" : "Movie",
                                                    variant: AppTextVariant.caption,
                                                    color: item?.contentType == "web_series" ? Colors.blue : Colors.orange,
                                                    weight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                // Title
                                                AppText(
                                                  item?.contentName ?? "Unknown Title",
                                                  variant: AppTextVariant.subtitle,
                                                  weight: FontWeight.bold,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 6),
                                                // Watched date
                                                Row(
                                                  children: [
                                                    const PhosphorIcon(
                                                      PhosphorIconsDuotone.clock,
                                                      color: Colors.white54,
                                                      size: 14,
                                                    ),
                                                    const SizedBox(width: 6),
                                                    AppText(
                                                      formatWatchedDate(DateTime.parse(item?.lastWatchedTime ?? DateTime.now().toString())),
                                                      variant: AppTextVariant.caption,
                                                      color: Colors.white54,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                // Progress info
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: LinearProgressIndicator(
                                                        value: progress.clamp(0.0, 1.0),
                                                        backgroundColor: Colors.white.withOpacity(0.2),
                                                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                                                        minHeight: 3,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    AppText(
                                                      "${(progress * 100).toInt()}%",
                                                      variant: AppTextVariant.caption,
                                                      color: Colors.white70,
                                                      weight: FontWeight.w500,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Arrow icon
                                    const PhosphorIcon(
                                      PhosphorIconsRegular.caretRight,
                                      color: Colors.white54,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: _wl.data?.length ?? 0,
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 20),
                  ),
                ],
              ),
            ),
    );
  }
}
