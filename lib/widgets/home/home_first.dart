import 'package:catchmflixx/api/content/common.dart';
import 'package:catchmflixx/models/content/search.list.model.dart';
import 'package:flutter/material.dart';
import 'package:catchmflixx/theme/typography.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';

ContentList _cList = ContentList();

class HomeFirst extends StatefulWidget {
  const HomeFirst({super.key});

  @override
  State<HomeFirst> createState() => _HomeFirstState();
}

class _HomeFirstState extends State<HomeFirst> with TickerProviderStateMixin {
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    getData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> getData() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      ContentManager ct = ContentManager();
      ContentList? data = await ct.searchContent("");
      
      if (mounted) {
        if (data != null && data.results?.success == true) {
          setState(() {
            _cList = data;
            _isLoading = false;
          });
        } else {
          setState(() {
            _hasError = true;
            _errorMessage = 'Failed to load content';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Network error occurred: $e';
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildLoadingState() {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _fadeController,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Loading skeleton for section header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Container(
                        height: 16,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Loading skeleton for cards
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withOpacity(0.03),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.05),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(4, (index) => 
                          Padding(
                            padding: EdgeInsets.only(
                              left: index == 0 ? 16 : 8,
                              right: index == 3 ? 16 : 0,
                            ),
                            child: SizedBox(
                              width: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 240,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    height: 12,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _fadeController,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.red.withOpacity(0.1),
              border: Border.all(
                color: Colors.red.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red.withOpacity(0.8),
                  size: 48,
                ),
                const SizedBox(height: 16),
                const AppText('Oops! Something went wrong',
                    variant: AppTextVariant.subtitle,
                    weight: FontWeight.w600,
                    color: Colors.white),
                const SizedBox(height: 8),
                AppText(
                  _errorMessage,
                  variant: AppTextVariant.body,
                  color: Colors.white.withOpacity(0.7),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: getData,
                  icon: const Icon(Icons.refresh),
                  label: const AppText('Try Again', variant: AppTextVariant.subtitle),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentState() {
    if (_cList.results?.success == false || _cList.results == null) {
      return _buildErrorState();
    }

    // Check if we have data
    final data = _cList.results?.data;
    if (data == null || data.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.02),
              border: Border.all(
                color: Colors.white.withOpacity(0.05),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.movie_outlined,
                  color: Colors.white.withOpacity(0.5),
                  size: 48,
                ),
                const SizedBox(height: 16),
                const AppText('No editorial picks right now',
                    variant: AppTextVariant.subtitle,
                    weight: FontWeight.w600),
                const SizedBox(height: 8),
                AppText(
                  'Check back later for fresh recommendations',
                  variant: AppTextVariant.body,
                  color: Colors.white.withOpacity(0.7),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Custom editorial rail distinct from the rest of the app
    return SliverToBoxAdapter(
      child: Builder(
        builder: (context) {
          final size = MediaQuery.of(context).size;
          final double cardHeight = size.width < 380 ? 160 : 180;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const AppText(
                      'Editorial Picks',
                      variant: AppTextVariant.sectionTitle,
                      weight: FontWeight.w700,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: getData,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: const AppText(
                        'Refresh',
                        variant: AppTextVariant.bodySmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                AppText(
                  'A hand-picked selection from Catch M Flixx',
                  variant: AppTextVariant.bodySmall,
                  color: Colors.white.withOpacity(0.7),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: cardHeight,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: data.length.clamp(0, 12),
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return _EditorialCard(
                        title: item.metaData?.title ?? 'Untitled',
                        subtitle: item.metaData?.description ?? '',
                        imageUrl: item.thumbnail ?? '',
                        onTap: () => navigateToPage(
                          context,
                          (item.type == 'movie')
                              ? "/movie/${item.uuid ?? ''}"
                              : "/series/${item.uuid ?? ''}",
                        ),
                        height: cardHeight,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Start fade animation when widget builds
    if (_isLoading || _hasError) {
      _fadeController.forward();
    }

    if (_isLoading) {
      return _buildLoadingState();
    }
    
    if (_hasError) {
      return _buildErrorState();
    }
    
    return _buildContentState();
  }
}

class _EditorialCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final double height;
  final VoidCallback onTap;

  const _EditorialCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final double width = height * (16 / 9);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl.isNotEmpty)
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.black),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(color: Colors.black);
                },
              )
            else
              Container(color: Colors.black),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                color: Colors.black.withOpacity(0.35),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppText(
                      'EDITORIAL',
                      variant: AppTextVariant.label,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      title,
                      variant: AppTextVariant.subtitle,
                      weight: FontWeight.w700,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
