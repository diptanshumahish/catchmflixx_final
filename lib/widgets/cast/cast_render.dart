import 'package:catchmflixx/api/content/common.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/models/cast/cast.model.dart';
import 'package:catchmflixx/widgets/cast/cast_card.dart';
import 'package:catchmflixx/utils/responsive/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

CastResponse _castResponse = CastResponse(data: [], success: false);

class CastRender extends StatefulWidget {
  final String uuid;
  const CastRender({super.key, required this.uuid});

  @override
  State<CastRender> createState() => _CastRenderState();
}

class _CastRenderState extends State<CastRender> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    getData();
    super.initState();
  }

  getData() async {
    ContentManager c = ContentManager();
    final data = await c.getCast(widget.uuid);
    if (data != null) {
      setState(() {
        _castResponse = data;
      });
      _fadeController.forward();
      _slideController.forward();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    if (_castResponse.data == null || _castResponse.data!.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    
    return SliverToBoxAdapter(
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            margin: ResponsiveUtils.getResponsiveEdgeInsets(
              context,
              basePadding: EdgeInsets.symmetric(
                horizontal: size.height / 40,
                vertical: size.height / 60,
              ),
              smallScreenPadding: EdgeInsets.symmetric(
                horizontal: size.height / 35,
                vertical: size.height / 70,
              ),
              largeScreenPadding: EdgeInsets.symmetric(
                horizontal: size.height / 45,
                vertical: size.height / 50,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Header
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Cast",
                      style: TextStyles.getResponsiveSectionHeading(context).copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "${_castResponse.data!.length} members",
                        style: TextStyles.smallSubText.copyWith(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Cast Cards
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: _castResponse.data!.length,
                    itemBuilder: (context, index) {
                      final cast = _castResponse.data![index];
                      return Container(
                        margin: EdgeInsets.only(
                          right: index == _castResponse.data!.length - 1 ? 0 : 16,
                        ),
                        child: CastCard(
                          name: cast.actor?.name ?? "",
                          role: cast.movieRole ?? "actor",
                          image: cast.actor?.image ?? "",
                        ),
                      ).animate().fadeIn(
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        delay: Duration(milliseconds: index * 50),
                      ).slideX(
                        begin: 0.3,
                        duration: Duration(milliseconds: 400 + (index * 100)),
                        delay: Duration(milliseconds: index * 50),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
