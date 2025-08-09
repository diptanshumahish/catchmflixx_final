// unified typography used; old text styles not needed here
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SectionCard extends StatefulWidget {
  final String playLink;
  final String fullDetailsId;
  final String title;
  final String subTitle;
  final double? progress;
  final String poster;
  final String type;
  
  const SectionCard({
    super.key,
    required this.playLink,
    required this.type,
    required this.poster,
    required this.fullDetailsId,
    required this.title,
    required this.subTitle,
    this.progress,
  });

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _scaleController.forward().then((_) => _scaleController.reverse());
        navigateToPage(
          context,
          widget.type == "movie" ? "/movie/${widget.fullDetailsId}" : "/series/${widget.fullDetailsId}",
        );
      },
      child: FadeTransition(
        opacity: _fadeController,
        child: ScaleTransition(
          scale: Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: _fadeController,
            curve: Curves.easeOutCubic,
          )),
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced image container with loading states and fallbacks
                Container(
                  height: 240,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        // Main image with caching and error handling
                        if (widget.poster.isNotEmpty)
                          CachedNetworkImage(
                            imageUrl: widget.poster,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 240,
                            placeholder: (context, url) => Container(
                              color: Colors.grey.withOpacity(0.2),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white.withOpacity(0.6),
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => _buildImageFallback(),
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        else
                          _buildImageFallback(),
                        
                        // Progress indicator overlay
                        if (widget.progress != null)
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
                                alignment: Alignment.centerLeft,
                                widthFactor: (widget.progress! / 100),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.yellow, Colors.orange],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        
                        // Content type badge
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          child: AppText(
                            widget.type == "movie" ? "Movie" : "Series",
                            variant: AppTextVariant.label,
                          ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Enhanced text content
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        widget.title,
                        variant: AppTextVariant.body,
                        weight: FontWeight.w600,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        widget.subTitle,
                        variant: AppTextVariant.bodySmall,
                        color: Colors.white.withOpacity(0.7),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageFallback() {
    return Container(
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.withOpacity(0.3),
            Colors.grey.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.type == "movie" ? Icons.movie : Icons.tv,
            size: 48,
            color: Colors.white.withOpacity(0.5),
          ),
          const SizedBox(height: 8),
          Text(
            widget.type == "movie" ? "Movie" : "Series",
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
