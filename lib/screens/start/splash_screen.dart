import 'dart:async';
import 'dart:math' as math;
import 'package:catchmflixx/constants/images.dart';
import 'package:catchmflixx/constants/text.dart';

import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:catchmflixx/utils/version/version_check.dart';
import 'package:catchmflixx/widgets/common/loading/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:catchmflixx/widgets/content/series/video_background.dart';
 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool _showLogo = false;
  bool _showText = false;
  late AnimationController _grainController;
  final List<GrainDot> _grainDots = [];
  final math.Random _random = math.Random();
  bool _glitch = false;
  Timer? _glitchTimer;
  List<GlitchSlice> _glitchSlices = [];

  @override
  void initState() {
    super.initState();
    _grainController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    for (int i = 0; i < 320; i++) {
      _grainDots.add(
        GrainDot(
          dx: _random.nextDouble(),
          dy: _random.nextDouble(),
          size: 0.6 + _random.nextDouble() * 1.4,
          baseOpacity: 0.02 + _random.nextDouble() * 0.06,
          phase: _random.nextDouble() * 2 * math.pi,
        ),
      );
    }
    _startAnimations();
    _startDataCheck();

    // Periodic, brief glitch burst for the text logo
    _glitchTimer = Timer.periodic(const Duration(milliseconds: 2000), (timer) {
      if (!mounted) return;
      _generateGlitchSlices();
      setState(() => _glitch = true);
      Future.delayed(const Duration(milliseconds: 160), () {
        if (mounted) setState(() => _glitch = false);
      });
    });
  }

  void _generateGlitchSlices() {
    const double textHeightPx = 35.0;
    final int count = 8 + _random.nextInt(6); // 8-13 slices
    final List<GlitchSlice> slices = [];
    for (int i = 0; i < count; i++) {
      final double h = 2.0 + _random.nextDouble() * 5.0;
      final double top = (_random.nextDouble() * (textHeightPx - h)).clamp(0.0, textHeightPx - h);
      final double offsetX = (_random.nextBool() ? 1 : -1) * (2.0 + _random.nextDouble() * 6.0);
      final List<Color> palette = const [Color(0xFF00FFFF), Color(0xFFFF005D), Colors.white];
      final Color color = palette[_random.nextInt(palette.length)];
      final double opacity = 0.35 + _random.nextDouble() * 0.45;
      slices.add(GlitchSlice(top: top, height: h, offsetX: offsetX, color: color, opacity: opacity));
    }
    _glitchSlices = slices;
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _showLogo = true);
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _showText = true);
    });
  }

  void _startDataCheck() {
    Future.delayed(const Duration(seconds: 4), () async {
      await checkData();
    });
  }

  Future<void> checkData() async {
    for (int i = 0; i < 3; i++) {
      try {
        final data = await isVersionUpToDate();
        if (!mounted) return;
        if (data == true) {
          navigateToPage(context, "/check-login", isReplacement: true);
          return;
        } else {
          navigateToPage(context, "/version");
          return;
        }
      } catch (e) {
        if (!mounted) return;
        ToastShow.returnToast(
            "Network error, retrying (${2 - i} attempts left)");
        await Future.delayed(const Duration(seconds: 2));
      }
    }
    if (mounted) navigateToPage(context, "/error");
  }

  @override
  void dispose() {
    _grainController.dispose();
    _glitchTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: VideoBackground(
              videoUrl: "",
              fallbackImageUrl: "",
              height: size.height,
              width: size.width,
              fit: BoxFit.cover,
              fallbackColor: Colors.black,
            ),
          ),

          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.35)),
          ),

          Positioned.fill(
            child: IgnorePointer(
              child: Transform.rotate(
                angle: -6 * math.pi / 180,
                child: Align(
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: 0.05,
                    child: SvgPicture.asset(
                      CatchMFlixxImages.ticket,
                      width: size.width * 0.8,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Film grain overlay (animated flicker)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _grainController,
                builder: (context, _) {
                  return CustomPaint(
                    painter: GrainPainter(
                      dots: _grainDots,
                      t: _grainController.value,
                    ),
                  );
                },
              ),
            ),
          ),

          // Scanline overlay
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: ScanlinePainter(opacity: 0.03, spacing: 3),
              ),
            ),
          ),
          // Main content
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with subtle, professional fade/scale
                  Animate(
                    effects: [
                      if (_showLogo) ...[
                        const FadeEffect(
                          curve: Curves.easeOutCubic,
                          duration: Duration(milliseconds: 500),
                        ),
                        const ScaleEffect(
                          begin: Offset(0.94, 0.94),
                          end: Offset(1, 1),
                          curve: Curves.easeOutCubic,
                          duration: Duration(milliseconds: 500),
                        ),
                      ]
                    ],
                    child: Image.asset(
                      CatchMFlixxImages.logo,
                      height: 100,
                      width: 100,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Animate(
                    effects: [
                      if (_showText) ...[
                        const FadeEffect(
                          curve: Curves.easeOutCubic,
                          duration: Duration(milliseconds: 450),
                        ),
                        const SlideEffect(
                          begin: Offset(0, 0.04),
                          curve: Curves.easeOutCubic,
                          duration: Duration(milliseconds: 450),
                        ),
                      ]
                    ],
                    child: SizedBox(
                      height: 40,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            CatchMFlixxImages.textLogo,
                            height: 35,
                          ),
                          if (_glitch) ...[
                            Transform.translate(
                              offset: const Offset(2.5, -1.5),
                              child: ColorFiltered(
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF00FFFF),
                                  BlendMode.srcATop,
                                ),
                                child: Opacity(
                                  opacity: 0.6,
                                  child: SvgPicture.asset(
                                    CatchMFlixxImages.textLogo,
                                    height: 35,
                                  ),
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: const Offset(-2.5, 1.2),
                              child: ColorFiltered(
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFFFF005D),
                                  BlendMode.srcATop,
                                ),
                                child: Opacity(
                                  opacity: 0.6,
                                  child: SvgPicture.asset(
                                    CatchMFlixxImages.textLogo,
                                    height: 35,
                                  ),
                                ),
                              ),
                            ),
                            // Random horizontal slices
                            ..._glitchSlices.map((s) => Positioned(
                                  top: null,
                                  bottom: null,
                                  left: 0,
                                  right: 0,
                                  child: Transform.translate(
                                    offset: Offset(s.offsetX, 0),
                                    child: Opacity(
                                      opacity: s.opacity,
                                      child: ShaderMask(
                                        shaderCallback: (Rect bounds) {
                                          return LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              s.color,
                                              Colors.transparent,
                                            ],
                                            stops: [
                                              (s.top / 35.0).clamp(0, 1),
                                              ((s.top + s.height / 2) / 35.0).clamp(0, 1),
                                              ((s.top + s.height) / 35.0).clamp(0, 1),
                                            ],
                                          ).createShader(bounds);
                                        },
                                        blendMode: BlendMode.srcATop,
                                        child: SvgPicture.asset(
                                          CatchMFlixxImages.textLogo,
                                          height: 35,
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // (Removed subtitle for minimalism)
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  const  Opacity(
                      opacity: 0.85,
                      child: CoolLoadingIndicator(),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'version ${ConstantTexts.versionInfo}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GlitchSlice {
  final double top;
  final double height;
  final double offsetX;
  final Color color;
  final double opacity;
  GlitchSlice({
    required this.top,
    required this.height,
    required this.offsetX,
    required this.color,
    required this.opacity,
  });
}

class GrainDot {
  final double dx;
  final double dy;
  final double size;
  final double baseOpacity;
  final double phase;
  const GrainDot({
    required this.dx,
    required this.dy,
    required this.size,
    required this.baseOpacity,
    required this.phase,
  });
}

class GrainPainter extends CustomPainter {
  final List<GrainDot> dots;
  final double t;
  GrainPainter({required this.dots, required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    for (final d in dots) {
      final x = d.dx * size.width;
      final y = d.dy * size.height;
      // Subtle flicker per dot
      final flicker = 0.6 + 0.4 * math.sin(d.phase + t * 8.0);
      final alpha = (255.0 * (d.baseOpacity * flicker)).clamp(0, 25).toInt();
      paint.color = Colors.white.withAlpha(alpha);
      canvas.drawCircle(Offset(x, y), d.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant GrainPainter oldDelegate) => oldDelegate.t != t;
}

class ScanlinePainter extends CustomPainter {
  final double opacity;
  final double spacing;
  ScanlinePainter({this.opacity = 0.03, this.spacing = 3});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..strokeWidth = 1;
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
