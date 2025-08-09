import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class VideoBackground extends StatefulWidget {
  final String videoUrl;
  final String fallbackImageUrl;
  final double height;
  final double width;
  final BoxFit fit;
  final bool autoPlay;
  final bool loop;
  final Duration? startAt;
  final Color fallbackColor;

  const VideoBackground({
    super.key,
    required this.videoUrl,
    required this.fallbackImageUrl,
    required this.height,
    required this.width,
    this.fit = BoxFit.cover,
    this.autoPlay = true,
    this.loop = true,
    this.startAt,
    this.fallbackColor = Colors.black,
  });

  @override
  State<VideoBackground> createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<VideoBackground> with SingleTickerProviderStateMixin {
  VideoPlayerController? _videoController;
  bool _isVideoLoading = false;
  bool _isVideoReady = false;
  bool _hasVideoError = false;
  bool _showVideo = false;
  Timer? _loadTimer;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    // Delay video loading to prioritize UI rendering
    _loadTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted && widget.videoUrl.isNotEmpty) {
        _loadVideo();
      }
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _loadTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadVideo() async {
    if (_videoController != null || _isVideoLoading) return;
    
    setState(() {
      _isVideoLoading = true;
      _hasVideoError = false;
    });
    
    try {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
        formatHint: VideoFormat.hls,
      );
      
      await _videoController!.initialize();
      
      if (mounted) {
        setState(() {
          _isVideoReady = true;
          _isVideoLoading = false;
        });
        
        // Mute the video
        await _videoController!.setVolume(0.0);
        
        if (widget.startAt != null) {
          await _videoController!.seekTo(widget.startAt!);
        }
        
        if (widget.autoPlay) {
          _videoController!.play();
        }
        
        // Start fade transition
        setState(() {
          _showVideo = true;
        });
        _fadeController.forward();
        
        // Loop the video if enabled
        if (widget.loop) {
          _videoController!.addListener(() {
            if (_videoController!.value.position >= _videoController!.value.duration) {
              _videoController!.seekTo(Duration.zero);
              _videoController!.play();
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isVideoLoading = false;
          _hasVideoError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Stack(
        children: [
          if (widget.fallbackImageUrl.isNotEmpty)
            Image.network(
              widget.fallbackImageUrl,
              height: widget.height,
              width: widget.width,
              fit: widget.fit,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: widget.height,
                  width: widget.width,
                  color: widget.fallbackColor,
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: widget.height,
                  width: widget.width,
                  color: widget.fallbackColor,
                );
              },
            )
          else
            Container(
              height: widget.height,
              width: widget.width,
              color: widget.fallbackColor,
            ),
          
          if (_isVideoReady && _videoController != null && !_hasVideoError && _showVideo)
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: SizedBox.expand(
                    child: ClipRect(
                      child: OverflowBox(
                        maxWidth: double.infinity,
                        maxHeight: double.infinity,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _videoController!.value.size.width,
                            height: _videoController!.value.size.height,
                            child: VideoPlayer(_videoController!),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
