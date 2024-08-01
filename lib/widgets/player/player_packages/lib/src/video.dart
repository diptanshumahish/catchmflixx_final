import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:catchmflixx/api/user/user_activity/user.activity.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/utils/player/return_quality.dart';
import 'package:catchmflixx/utils/vibrate/vibrations.dart';
import 'package:catchmflixx/widgets/player/player_packages/lib/lecle_yoyo_player.dart';
import 'package:catchmflixx/widgets/player/player_packages/lib/src/utils/extensions/duration_extensions.dart';
import 'package:catchmflixx/widgets/player/player_packages/lib/src/utils/extensions/screen_size_extensions.dart';
import 'package:catchmflixx/widgets/player/player_packages/lib/src/utils/package_utils/file_utils.dart';
import 'package:catchmflixx/widgets/player/player_packages/lib/src/widgets/video_controls.dart';
import 'package:catchmflixx/widgets/player/player_packages/lib/src/widgets/video_loading.dart';
import 'package:catchmflixx/widgets/player/player_packages/lib/src/widgets/video_playback_speed.dart';
import 'package:catchmflixx/widgets/player/player_packages/lib/src/widgets/video_quality_widget.dart';
import 'package:catchmflixx/widgets/player/player_packages/lib/src/widgets/video_speed_widget.dart';
import 'package:catchmflixx/widgets/player/player_packages/lib/src/widgets/video_topbar.dart';
import 'package:catchmflixx/widgets/player/player_packages/lib/src/widgets/widget_bottombar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'model/models.dart';
import 'responses/regex_response.dart';
import 'widgets/video_quality_picker.dart';

class YoYoPlayer extends ConsumerStatefulWidget {
  final String url;
  final VideoStyle videoStyle;
  final VideoLoadingStyle videoLoadingStyle;
  final double aspectRatio;
  final void Function(bool fullScreenTurnedOn)? onFullScreen;
  final void Function(String videoType)? onPlayingVideo;
  final void Function(bool isPlaying)? onPlayButtonTap;
  final ValueChanged<VideoPlayerValue>? onFastForward;
  final ValueChanged<VideoPlayerValue>? onRewind;
  final ValueChanged<VideoPlayerValue>? onLiveDirectTap;
  final void Function(bool showMenu, bool m3u8Show)? onShowMenu;
  final void Function(VideoPlayerController controller)? onVideoInitCompleted;
  final Map<String, String>? headers;
  final bool autoPlayVideoAfterInit;
  final bool displayFullScreenAfterInit;
  final void Function(List<File>? files)? onCacheFileCompleted;
  final void Function(dynamic error)? onCacheFileFailed;
  final bool allowCacheFile;
  final Future<ClosedCaptionFile>? closedCaptionFile;
  final VideoPlayerOptions? videoPlayerOptions;
  final String title;
  final String details;
  final String id;
  final Duration? last;

  const YoYoPlayer({
    super.key,
    required this.url,
    required this.title,
    required this.details,
    required this.id,
    this.last,
    this.aspectRatio = 16 / 9,
    this.videoStyle = const VideoStyle(),
    this.videoLoadingStyle = const VideoLoadingStyle(),
    this.onFullScreen,
    this.onPlayingVideo,
    this.onPlayButtonTap,
    this.onShowMenu,
    this.onFastForward,
    this.onRewind,
    this.headers,
    this.autoPlayVideoAfterInit = true,
    this.displayFullScreenAfterInit = false,
    this.allowCacheFile = false,
    this.onCacheFileCompleted,
    this.onCacheFileFailed,
    this.onVideoInitCompleted,
    this.closedCaptionFile,
    this.videoPlayerOptions,
    this.onLiveDirectTap,
  });

  @override
  ConsumerState<YoYoPlayer> createState() => _YoYoPlayerState();
}

class _YoYoPlayerState extends ConsumerState<YoYoPlayer>
    with SingleTickerProviderStateMixin {
  String? playType;
  late AnimationController controlBarAnimationController;
  Animation<double>? controlTopBarAnimation;
  Animation<double>? controlBottomBarAnimation;
  late VideoPlayerController controller;
  bool hasInitError = false;
  String? videoDuration;
  String? videoSeek;
  Duration? duration;
  double? videoSeekSecond;
  double? videoDurationSecond;
  List<M3U8Data> yoyo = [];
  List<AudioModel> audioList = [];
  String? m3u8Content;
  String? subtitleContent;
  bool m3u8Show = false;
  bool playBackShow = false;
  bool fullScreen = false;
  bool showMenu = false;
  bool showSubtitles = false;
  bool? isOffline;
  String m3u8Quality = "Auto";
  double playbackSpeed = 1.0;
  Timer? showTime;
  OverlayEntry? overlayEntry;
  GlobalKey videoQualityKey = GlobalKey();
  Duration? lastPlayedPos;
  bool isAtLivePosition = true;

  @override
  void initState() {
    super.initState();

    urlCheck(widget.url);

    controlBarAnimationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    controlTopBarAnimation = Tween(begin: -(36.0 + 0.0 * 2), end: 0.0)
        .animate(controlBarAnimationController);
    controlBottomBarAnimation = Tween(begin: -(36.0 + 0.0 * 2), end: 0.0)
        .animate(controlBarAnimationController);

    if (widget.videoStyle.enableSystemOrientationsOverride) {
      SystemChrome.setPreferredOrientations(
        widget.videoStyle.orientation ?? DeviceOrientation.values,
      );
    }
  }

  @override
  void dispose() {
    update();
    m3u8Clean();
    controller.dispose();
    controlBarAnimationController.dispose();
    super.dispose();
  }

  update() async {
    UserActivity ua = UserActivity();
    await ua.addWatchProgress(widget.id, controller.value.position.inSeconds);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: fullScreen
          ? MediaQuery.of(context).size.calculateAspectRatio()
          : widget.aspectRatio,
      child: controller.value.isInitialized
          ? Stack(
              children: <Widget>[
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      toggleControls();
                      removeOverlay();
                    },
                    onDoubleTap: () {
                      togglePlay();
                      removeOverlay();
                    },
                    child: Animate(
                      effects: const [FadeEffect()],
                      child: Opacity(
                        opacity: showMenu ? 0.4 : 1,
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: controller.value.aspectRatio,
                            child: VideoPlayer(controller),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ...videoBuiltInChildren(),
              ],
            )
          : VideoLoading(loadingStyle: widget.videoLoadingStyle),
    );
  }

  List<Widget> videoBuiltInChildren() {
    return [
      liveDirectButton(),
      bottomBar(),
      actionBar(),
      controls(),
      topBar()

      // m3u8List(),
    ];
  }

  Widget topBar() {
    return VideoTopBar(
      title: widget.title,
      details: widget.details,
      act: () async {
        await ref.read(watchHistoryProvider.notifier).updateState();
        Navigator.of(context).pop();
      },
      showBar: showMenu,
    );
  }

  Widget controls() {
    return VideoControls(
      controller: controller,
      showControls: showMenu,
      onPlayButtonTap: () async {
        await vibrateTap();
        togglePlay();
      },
    );
  }

  /// Video player ActionBar
  Widget actionBar() {
    return Visibility(
      visible: showMenu,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: widget.videoStyle.actionBarPadding ??
              const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
          child: SafeArea(
            bottom: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Animate(
                  effects: const [
                    FadeEffect(delay: Duration(milliseconds: 100))
                  ],
                  child: VideoQualityWidget(
                    key: videoQualityKey,
                    videoStyle: widget.videoStyle,
                    onTap: () {
                      setState(() {
                        m3u8Show = !m3u8Show;

                        if (m3u8Show) {
                          showOverlay();
                        } else {
                          removeOverlay();
                        }
                      });
                    },
                    child: Row(
                      children: [
                        const PhosphorIcon(
                          PhosphorIconsRegular.gearFine,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text("Quality ${returnQuality(m3u8Quality)}",
                            style: widget.videoStyle.qualityStyle),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Animate(
                  effects: const [
                    FadeEffect(delay: Duration(milliseconds: 200))
                  ],
                  child: VideoSpeedWidget(
                      onTap: () {
                        setState(() {
                          playBackShow = !playBackShow;

                          if (playBackShow) {
                            showSpeedOverLay();
                          } else {
                            removeOverlay();
                          }
                        });
                      },
                      child: Row(
                        children: [
                          const PhosphorIcon(
                            PhosphorIconsRegular.speedometer,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text("Speed ${controller.value.playbackSpeed}",
                              style: widget.videoStyle.qualityStyle),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Video player BottomBar
  Widget bottomBar() {
    return Visibility(
      visible: showMenu,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: PlayerBottomBar(
          controller: controller,
          videoSeek: videoSeek ?? '00:00:00',
          videoDuration: videoDuration ?? '00:00:00',
          videoStyle: widget.videoStyle,
          showBottomBar: showMenu,
          onPlayButtonTap: () => togglePlay(),
          onFastForward: (value) {
            widget.onFastForward?.call(value);
          },
          onRewind: (value) {
            widget.onRewind?.call(value);
          },
        ),
      ),
    );
  }

  /// Video player live direct button
  Widget liveDirectButton() {
    return Visibility(
      visible: widget.videoStyle.showLiveDirectButton && showMenu,
      child: Align(
        alignment: Alignment.topLeft,
        child: IntrinsicWidth(
          child: InkWell(
            onTap: () {
              controller.seekTo(controller.value.duration).then((value) {
                widget.onLiveDirectTap?.call(controller.value);
                controller.play();
              });
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14.0,
                vertical: 14.0,
              ),
              margin: const EdgeInsets.only(left: 9.0),
              child: Row(
                children: [
                  Container(
                    width: widget.videoStyle.liveDirectButtonSize,
                    height: widget.videoStyle.liveDirectButtonSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isAtLivePosition
                          ? widget.videoStyle.liveDirectButtonColor
                          : widget.videoStyle.liveDirectButtonDisableColor,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    widget.videoStyle.liveDirectButtonText ?? 'Live',
                    style: widget.videoStyle.liveDirectButtonTextStyle ??
                        const TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Video quality list
  Widget m3u8List() {
    RenderBox? renderBox =
        videoQualityKey.currentContext?.findRenderObject() as RenderBox?;

    return VideoQualityPicker(
      videoData: yoyo,
      videoStyle: widget.videoStyle,
      showPicker: m3u8Show,
      positionRight: (renderBox?.size.width ?? 0.0) / 3,
      onQualitySelected: (data) {
        if (data?.dataQuality != m3u8Quality) {
          setState(() {
            m3u8Quality = data.dataQuality ?? m3u8Quality;
          });
          onSelectQuality(data);
          print(
              "--- Quality select ---\nquality : ${data?.dataQuality}\nlink : ${data?.dataURL}");
        }
        setState(() {
          m3u8Show = false;
        });
        removeOverlay();
      },
    );
  }

  Widget speedList() {
    RenderBox? renderBox =
        videoQualityKey.currentContext?.findRenderObject() as RenderBox?;

    return VideoPlayBackSpeed(
      videoData: const [0.25, 0.50, 0.75, 1.0, 1.25, 1.50, 1.75, 2.0],
      videoStyle: widget.videoStyle,
      showPicker: playBackShow,
      positionRight: (renderBox?.size.width ?? 0.0) / 3,
      onQualitySelected: (data) {
        if (data != playbackSpeed) {
          setState(() {
            playbackSpeed = data;
          });
          onPlayBackSpeedChange(data);
        }
        setState(() {
          playBackShow = false;
        });
        removeOverlay();
      },
    );
  }

  void urlCheck(String url) {
    final netRegex = RegExp(RegexResponse.regexHTTP);
    final isNetwork = netRegex.hasMatch(url);
    final uri = Uri.parse(url);

    print("Parsed url data end : ${uri.pathSegments.last}");
    if (isNetwork) {
      setState(() {
        isOffline = false;
      });
      if (uri.pathSegments.last.endsWith("mkv")) {
        setState(() {
          playType = "MKV";
        });
        print("urlEnd : mkv");
        widget.onPlayingVideo?.call("MKV");

        videoControlSetup(url);

        if (widget.allowCacheFile) {
          FileUtils.cacheFileToLocalStorage(
            url,
            fileExtension: 'mkv',
            headers: widget.headers,
            onSaveCompleted: (file) {
              widget.onCacheFileCompleted?.call(file != null ? [file] : null);
            },
            onSaveFailed: widget.onCacheFileFailed,
          );
        }
      } else if (uri.pathSegments.last.endsWith("mp4")) {
        setState(() {
          playType = "MP4";
        });
        print("urlEnd: $playType");
        widget.onPlayingVideo?.call("MP4");

        videoControlSetup(url);

        if (widget.allowCacheFile) {
          FileUtils.cacheFileToLocalStorage(
            url,
            fileExtension: 'mp4',
            headers: widget.headers,
            onSaveCompleted: (file) {
              widget.onCacheFileCompleted?.call(file != null ? [file] : null);
            },
            onSaveFailed: widget.onCacheFileFailed,
          );
        }
      } else if (uri.pathSegments.last.endsWith('webm')) {
        setState(() {
          playType = "WEBM";
        });
        print("urlEnd: $playType");
        widget.onPlayingVideo?.call("WEBM");

        videoControlSetup(url);

        if (widget.allowCacheFile) {
          FileUtils.cacheFileToLocalStorage(
            url,
            fileExtension: 'webm',
            headers: widget.headers,
            onSaveCompleted: (file) {
              widget.onCacheFileCompleted?.call(file != null ? [file] : null);
            },
            onSaveFailed: widget.onCacheFileFailed,
          );
        }
      } else if (uri.pathSegments.last.endsWith("m3u8")) {
        setState(() {
          playType = "HLS";
        });
        widget.onPlayingVideo?.call("M3U8");

        print("urlEnd: M3U8");
        videoControlSetup(url);
        getM3U8(url);
      } else {
        print("urlEnd: null");
        videoControlSetup(url);
        getM3U8(url);
      }
      print("--- Current Video Status ---\noffline : $isOffline");
    } else {
      setState(() {
        isOffline = true;
        print(
            "--- Current Video Status ---\noffline : $isOffline \n --- :3 Done url check ---");
      });

      videoControlSetup(url);
    }
  }

  /// M3U8 Data Setup
  void getM3U8(String videoUrl) {
    if (yoyo.isNotEmpty) {
      print("${yoyo.length} : data start clean");
      m3u8Clean();
    }
    print("---- m3u8 fitch start ----\n$videoUrl\n--- please wait –––");
    m3u8Video(videoUrl);
  }

  Future<M3U8s?> m3u8Video(String? videoUrl) async {
    if (m3u8Content == null && videoUrl != null) {
      http.Response response =
          await http.get(Uri.parse(videoUrl), headers: widget.headers);
      if (response.statusCode == 200) {
        m3u8Content = utf8.decode(response.bodyBytes);

        print("--- HLS Data ----\n$m3u8Content");

        List<M3U8Data> videoTracks = [];

        // Split the content into lines
        List<String> lines = m3u8Content!.split('\n');
        String currentBandwidth = '';
        String currentResolution = '';
        String currentUri = '';

        for (int i = 0; i < lines.length; i++) {
          String line = lines[i].trim();

          // Check for video tracks
          if (line.startsWith('#EXT-X-STREAM-INF')) {
            Map<String, String> attributes = parseAttributes(line);
            currentResolution = attributes['RESOLUTION'] ?? '';
            currentBandwidth = attributes['BANDWIDTH'] ?? '';

            // The next line should be the URI
            if (i + 1 < lines.length) {
              currentUri = lines[i + 1].trim();
              if (!currentUri.startsWith('http')) {
                currentUri = resolveUrl(videoUrl, currentUri);
              }

              // Fetch and parse the quality-specific m3u8 file
              List<AudioTrack> audioTracks =
                  await fetchAudioTracksFromQualityM3U8(currentUri);

              print(
                  "Video track found: Resolution=$currentResolution, Bandwidth=$currentBandwidth, URI=$currentUri");
              videoTracks.add(M3U8Data(
                  dataQuality: currentResolution,
                  dataURL: currentUri,
                  audioTracks: audioTracks));
            }
          }
        }

        yoyo = videoTracks;

        M3U8s m3u8s = M3U8s(m3u8s: yoyo);

        print("Total M3U8 entries: ${yoyo.length}");
        for (var track in yoyo) {
          print(
              "Quality: ${track.dataQuality}, Audio tracks: ${track.audioTracks.length}");
          for (var audio in track.audioTracks) {
            print(" - Language: ${audio.language}, Name: ${audio.name}");
          }
        }

        return m3u8s;
      }
    }

    return null;
  }

  Future<List<AudioTrack>> fetchAudioTracksFromQualityM3U8(String url) async {
    List<AudioTrack> audioTracks = [];
    http.Response response =
        await http.get(Uri.parse(url), headers: widget.headers);
    if (response.statusCode == 200) {
      String content = utf8.decode(response.bodyBytes);
      List<String> lines = content.split('\n');

      for (String line in lines) {
        if (line.contains('#EXT-X-MEDIA:TYPE=AUDIO')) {
          Map<String, String> attributes = parseAttributes(line);
          String language = attributes['LANGUAGE'] ?? '';
          String name = attributes['NAME'] ?? '';

          audioTracks.add(AudioTrack(language: language, name: name, url: ''));
        }
      }
    }
    return audioTracks;
  }

  Map<String, String> parseAttributes(String line) {
    Map<String, String> attributes = {};
    RegExp attributeRegex = RegExp(r'(\w+)=("([^"]*)"|[^,]*)');
    Iterable<RegExpMatch> matches = attributeRegex.allMatches(line);
    for (var match in matches) {
      String key = match.group(1)!;
      String value = match.group(3) ?? match.group(2)!;
      attributes[key] = value.replaceAll('"', '');
    }
    return attributes;
  }

  String resolveUrl(String base, String relative) {
    Uri baseUri = Uri.parse(base);
    return baseUri.resolve(relative).toString();
  }

// Init video controller
  void videoControlSetup(String? url) async {
    videoInit(url);

    controller.addListener(listener);

    if (widget.autoPlayVideoAfterInit) {
      controller.play();
    }
    // widget.onVideoInitCompleted?.call(controller);
    if (widget.last != null) {
      await controller.seekTo(widget.last!);
    }
  }

// Video listener
  void listener() async {
    if (widget.videoStyle.showLiveDirectButton) {
      if (controller.value.position != controller.value.duration) {
        if (isAtLivePosition) {
          setState(() {
            isAtLivePosition = false;
          });
        }
      } else {
        if (!isAtLivePosition) {
          setState(() {
            isAtLivePosition = true;
          });
        }
      }
    }

    if (controller.value.isInitialized && controller.value.isPlaying) {
      if (!await WakelockPlus.enabled) {
        await WakelockPlus.enable();
      }

      setState(() {
        videoDuration = controller.value.duration.convertDurationToString();
        videoSeek = controller.value.position.convertDurationToString();
        videoSeekSecond = controller.value.position.inSeconds.toDouble();
        videoDurationSecond = controller.value.duration.inSeconds.toDouble();
      });
    } else {
      if (await WakelockPlus.enabled) {
        await WakelockPlus.disable();
        setState(() {});
      }
    }
  }

  void createHideControlBarTimer() {
    clearHideControlBarTimer();
    showTime = Timer(const Duration(milliseconds: 5000), () {
      // if (controller != null && controller.value.isPlaying) {
      if (controller.value.isPlaying) {
        if (showMenu) {
          setState(() {
            showMenu = false;
            m3u8Show = false;
            controlBarAnimationController.reverse();

            widget.onShowMenu?.call(showMenu, m3u8Show);
            removeOverlay();
          });
        }
      }
    });
  }

  void clearHideControlBarTimer() {
    showTime?.cancel();
  }

  void toggleControls() {
    clearHideControlBarTimer();

    if (!showMenu) {
      setState(() {
        showMenu = true;
      });
      widget.onShowMenu?.call(showMenu, m3u8Show);

      createHideControlBarTimer();
    } else {
      setState(() {
        m3u8Show = false;
        showMenu = false;
      });

      widget.onShowMenu?.call(showMenu, m3u8Show);
    }
    // setState(() {
    if (showMenu) {
      controlBarAnimationController.forward();
    } else {
      controlBarAnimationController.reverse();
    }
    // });
  }

  void togglePlay() {
    createHideControlBarTimer();
    if (controller.value.isPlaying) {
      controller.pause().then((_) {
        widget.onPlayButtonTap?.call(controller.value.isPlaying);
      });
    } else {
      controller.play().then((_) {
        widget.onPlayButtonTap?.call(controller.value.isPlaying);
      });
    }
    setState(() {});
  }

  void videoInit(String? url) {
    if (isOffline == false) {
      print(
          "--- Player status ---\nplay url : $url\noffline : $isOffline\n--- start playing –––");

      if (playType == "MP4" || playType == "WEBM") {
        // Play MP4 and WEBM video
        controller = VideoPlayerController.networkUrl(
          Uri.parse(url!),
          formatHint: VideoFormat.other,
          httpHeaders: widget.headers ?? const <String, String>{},
          closedCaptionFile: widget.closedCaptionFile,
          videoPlayerOptions: widget.videoPlayerOptions,
        )..initialize().then((value) => seekToLastPlayingPosition);
      } else if (playType == "MKV") {
        controller = VideoPlayerController.networkUrl(
          Uri.parse(url!),
          formatHint: VideoFormat.dash,
          httpHeaders: widget.headers ?? const <String, String>{},
          closedCaptionFile: widget.closedCaptionFile,
          videoPlayerOptions: widget.videoPlayerOptions,
        )..initialize().then((value) => seekToLastPlayingPosition);
      } else if (playType == "HLS") {
        controller = VideoPlayerController.networkUrl(
          Uri.parse(url!),
          formatHint: VideoFormat.hls,
          httpHeaders: widget.headers ?? const <String, String>{},
          closedCaptionFile: widget.closedCaptionFile,
          videoPlayerOptions: widget.videoPlayerOptions,
        )..initialize().then((_) async {
            setState(() => hasInitError = false);

            if (widget.last != null) {
              await controller.seekTo(widget.last!);
            } else {
              seekToLastPlayingPosition();
            }
          }).catchError((e) {
            setState(() => hasInitError = true);
          });
      }
    } else {
      print(
          "--- Player status ---\nplay url : $url\noffline : $isOffline\n--- start playing –––");
      controller = VideoPlayerController.file(
        File(url!),
        closedCaptionFile: widget.closedCaptionFile,
        videoPlayerOptions: widget.videoPlayerOptions,
      )..initialize().then((value) {
          setState(() => hasInitError = false);

          seekToLastPlayingPosition();
        }).catchError((e) {
          setState(() => hasInitError = true);
        });
    }
  }

  void _navigateLocally(context) async {
    if (!fullScreen) {
      if (ModalRoute.of(context)?.willHandlePopInternally ?? false) {
        Navigator.of(context).pop();
      }
      return;
    }

    ModalRoute.of(context)?.addLocalHistoryEntry(
      LocalHistoryEntry(
        onRemove: () {
          // if (fullScreen) ScreenUtils.toggleFullScreen(fullScreen);
        },
      ),
    );
  }

  void onSelectQuality(M3U8Data data) async {
    lastPlayedPos = await controller.position;

    if (controller.value.isPlaying) {
      await controller.pause();
    }

    if (data.dataQuality == "Auto") {
      videoControlSetup(data.dataURL);
    } else {
      try {
        String text;
        var file = await FileUtils.readFileFromPath(
            videoUrl: data.dataURL ?? '', quality: data.dataQuality ?? '');
        if (file != null) {
          print("Start reading file");
          text = await file.readAsString();
          print("Video file data: $text");

          if (data.dataURL != null) {
            playLocalM3U8File(data.dataURL!);
          } else {
            print('Play ${data.dataQuality} m3u8 video file failed');
          }
          // videoControlSetup(file);
        }
      } catch (e) {
        print("Couldn't read file ${data.dataQuality}: $e");
      }
    }
  }

  void onPlayBackSpeedChange(double data) {
    controller.setPlaybackSpeed(data);
  }

  void playLocalM3U8File(String url) {
    controller.dispose();
    controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
      closedCaptionFile: widget.closedCaptionFile,
      videoPlayerOptions: widget.videoPlayerOptions,
    )..initialize().then((_) {
        setState(() => hasInitError = false);
        seekToLastPlayingPosition();
        controller.play();
      }).catchError((e) {
        setState(() => hasInitError = true);
        print('Init local file error $e');
      });

    controller.addListener(listener);
    controller.play();
  }

  void m3u8Clean() async {
    print('Video list length: ${yoyo.length}');
    for (int i = 2; i < yoyo.length; i++) {
      try {
        var file = await FileUtils.readFileFromPath(
            videoUrl: yoyo[i].dataURL ?? '',
            quality: yoyo[i].dataQuality ?? '');
        var exists = await file?.exists();
        if (exists ?? false) {
          await file?.delete();
          print("Delete success $file");
        }
      } catch (e) {
        print("Couldn't delete file $e");
      }
    }
    try {
      print("Cleaning audio m3u8 list");
      audioList.clear();
      print("Cleaning audio m3u8 list completed");
    } catch (e) {
      print("Audio list clean error $e");
    }
    audioList.clear();
    try {
      print("Cleaning m3u8 data list");
      yoyo.clear();
      print("Cleaning m3u8 data list completed");
    } catch (e) {
      print("m3u8 video list clean error $e");
    }
  }

  void showOverlay() {
    setState(() {
      overlayEntry = OverlayEntry(
        canSizeOverlay: true,
        builder: (_) => m3u8List(),
      );
      Overlay.of(context).insert(overlayEntry!);
    });
  }

  void showSpeedOverLay() {
    setState(() {
      overlayEntry = OverlayEntry(
        canSizeOverlay: true,
        builder: (_) => speedList(),
      );
      Overlay.of(context).insert(overlayEntry!);
    });
  }

  void removeOverlay() {
    setState(() {
      overlayEntry?.remove();
      overlayEntry = null;
    });
  }

  void seekToLastPlayingPosition() async {
    if (lastPlayedPos != null) {
      await controller.seekTo(lastPlayedPos!);

      widget.onVideoInitCompleted?.call(controller);
      lastPlayedPos = null;
    }
  }
}
