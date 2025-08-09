import 'package:catchmflixx/api/user/profile/profile_api.dart';
import 'package:catchmflixx/api/user/user_activity/watch_later_list.dart';
import 'package:catchmflixx/constants/images.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

WatchLaterList _wl = WatchLaterList(data: [], success: false);

class MyToWatchList extends StatefulWidget {
  const MyToWatchList({super.key});

  @override
  State<MyToWatchList> createState() => _MyToWatchListState();
}

class _MyToWatchListState extends State<MyToWatchList> {
  bool _isLoading = true;

  getData() async {
    ProfileApi p = ProfileApi();
    WatchLaterList? data = await p.getWatchLater();
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
    final size = MediaQuery.of(context).size;
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
                    Text(
                      "Loading your watch list...",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
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
                        "My Watch List",
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
                      child: Text(
                        "Your personalized collection of movies and series you've saved to watch later",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  if (_wl.data!.isEmpty)
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
                              const Text(
                                "Your watch list is empty",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Start adding movies and series to your personal watch list to see them here",
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 16,
                                  height: 1.4,
                                ),
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
                              child: Text(
                                "${_wl.data?.length ?? 0} items",
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SliverList.builder(
                    itemBuilder: (context, idx) {
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
                                _wl.data?[idx].type == "movie"
                                    ? "/movie/${_wl.data?[idx].uuid ?? ""}"
                                    : "/series/${_wl.data?[idx].uuid ?? ""}",
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
                                        child: Text(
                                          '${idx + 1}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                                                  child: Image.network(
                                                    filterQuality: FilterQuality.high,
                                                    _wl.data?[idx].thumbnail ?? "",
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
                                                    color: _wl.data?[idx].type == "web_series"
                                                        ? Colors.blue.withOpacity(0.2)
                                                        : Colors.orange.withOpacity(0.2),
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(
                                                      color: _wl.data?[idx].type == "web_series"
                                                          ? Colors.blue.withOpacity(0.3)
                                                          : Colors.orange.withOpacity(0.3),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    _wl.data?[idx].type == "web_series"
                                                        ? "Series"
                                                        : "Movie",
                                                    style: TextStyle(
                                                      color: _wl.data?[idx].type == "web_series"
                                                          ? Colors.blue
                                                          : Colors.orange,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                // Title
                                                Text(
                                                  _wl.data?[idx].metaData?.title ?? "",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1.2,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 6),
                                                // Description
                                                Text(
                                                  _wl.data?[idx].metaData?.description ?? "",
                                                  style: const TextStyle(
                                                    color: Colors.white60,
                                                    fontSize: 14,
                                                    height: 1.3,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
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
