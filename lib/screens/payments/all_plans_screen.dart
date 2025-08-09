import 'package:catchmflixx/api/payments/payments.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/models/payments/subscription_model.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AllPlansScreen extends ConsumerStatefulWidget {
  const AllPlansScreen({super.key});

  @override
  ConsumerState<AllPlansScreen> createState() => _AllPlansScreenState();
}

class _AllPlansScreenState extends ConsumerState<AllPlansScreen>
    with TickerProviderStateMixin {
  String? selectedPlanId;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userSubscriptionProvider.notifier).updateState();
      _fadeController.forward();
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionData = ref.watch(userSubscriptionProvider);
    final currentPlan =
        ref.watch(userSubscriptionProvider.notifier).currentPlan;
    // Hide Free plan from list
    final filteredPlans =
        subscriptionData.data.where((p) => p.name != "Free").toList();

    if (subscriptionData.data.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xFF4F46E5),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Loading Plans...",
                style: TextStyles.headingMobile.copyWith(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final bool isFreeUser = (currentPlan?.name == "Free");

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.black,
            centerTitle: false,
            toolbarHeight: 64,
            title: FadeTransition(
              opacity: _fadeAnimation,
              child: AppText(
                isFreeUser ? "Upgrade to Premium" : "Manage Subscription",
                variant: AppTextVariant.title,
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          
          // Hero section with animated text (tailored to user's current plan)
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4F46E5).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.workspace_premium, color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              isFreeUser
                                  ? "Unlock ad‑free, unlimited streaming"
                                  : "Explore and switch plans anytime",
                              style: TextStyles.cardHeading.copyWith(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        isFreeUser
                            ? "Tap Select on a plan below to upgrade."
                            : "Choose another plan to change your subscription.",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Space between banner and plans
          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),

          // Plans list with enhanced cards (Free plan hidden)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList.builder(
              itemCount: filteredPlans.length,
              itemBuilder: (context, index) {
                final plan = filteredPlans[index];
                final isSelected = selectedPlanId == plan.id.toString();
                final isCurrentPlan = currentPlan?.id == plan.id;
                final isFreePlan = plan.name == "Free";

                return AnimatedBuilder(
                  animation: _fadeController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 50 * (1 - _fadeAnimation.value) * (index + 1)),
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          child: _buildPlanCard(plan, isSelected, isCurrentPlan, isFreePlan),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          
          // Bottom spacing for FAB
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
      
      // Enhanced Floating Action Button
      floatingActionButton: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton.extended(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: selectedPlanId == null
                ? const PhosphorIcon(
                    PhosphorIconsFill.heart,
                    color: Colors.white,
                    key: ValueKey('heart'),
                  )
                : const PhosphorIcon(
                    PhosphorIconsFill.checkCircle,
                    color: Colors.white,
                    key: ValueKey('check'),
                  ),
          ),
                             backgroundColor: selectedPlanId == null
                       ? Colors.grey.withOpacity(0.3)
                       : const Color(0xFF4F46E5),
          elevation: selectedPlanId == null ? 0 : 8,
          onPressed: selectedPlanId == null
              ? null
              : () async {
                  PaymentsManager pm = PaymentsManager();
                  final res =
                      await pm.paySubscription(selectedPlanId.toString());

                  if (res != null) {
                    final rawUrl =
                        res.transactionData.instrumentResponse.redirectInfo.url;

                    final safeUrl =
                        "https://www.catchmflixx.com/en/redirect?url=$rawUrl";

                    final uri = Uri.parse(safeUrl);

                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                    navigateToPage(context, "/base");
                  }
                  navigateToPage(context, "/base");
                  Navigator.of(context).pop();
                },
          label: Text(
            selectedPlanId == null
                ? (currentPlan?.name == "Free"
                    ? "Select a plan to continue"
                    : "You're on ${currentPlan?.name} plan")
                : _getSelectedPlanLabel(filteredPlans),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(Daum plan, bool isSelected, bool isCurrentPlan, bool isFreePlan) {
    return GestureDetector(
      onTap: () {
        if (plan.name != "Free" && plan.id != ref.read(userSubscriptionProvider.notifier).currentPlan?.id) {
          setState(() {
            selectedPlanId = plan.id.toString();
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4F46E5)
              : isCurrentPlan
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.white
                : isCurrentPlan
                    ? Colors.white.withOpacity(0.3)
                    : Colors.white.withOpacity(0.1),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            // Background pattern for premium plans
            if (!isFreePlan)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.02),
                  ),
                ),
              ),
            
            // Main content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan.name,
                              style: TextStyles.headingMobile.copyWith(
                                fontSize: 24,
                                color: isSelected ? Colors.white : Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (isCurrentPlan)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  "Your current plan",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (!isCurrentPlan)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4F46E5).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF4F46E5).withOpacity(0.4)),
                          ),
                          child: const Text(
                            "Upgrade",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      if (isSelected)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Color(0xFF6366F1),
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                                     // Price section
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       if (plan.price != "0.00") ...[
                         Row(
                           children: [
                             Text(
                               "₹${_calculateOriginalPrice(plan.price)}",
                               style: TextStyle(
                                 fontSize: 18,
                                 color: isSelected ? Colors.white54 : Colors.white38,
                                 fontWeight: FontWeight.w500,
                                 decoration: TextDecoration.lineThrough,
                                 decorationColor: isSelected ? Colors.white54 : Colors.white38,
                                 decorationThickness: 2,
                               ),
                             ),
                             const SizedBox(width: 12),
                             Container(
                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                               decoration: BoxDecoration(
                                 color: isSelected 
                                     ? Colors.white.withOpacity(0.2)
                                     : Colors.red.withOpacity(0.2),
                                 borderRadius: BorderRadius.circular(8),
                               ),
                               child: Text(
                                 _getDiscountPercentage(plan.price),
                                 style: TextStyle(
                                   fontSize: 12,
                                   color: isSelected ? Colors.white : Colors.red,
                                   fontWeight: FontWeight.w600,
                                 ),
                               ),
                             ),
                           ],
                         ),
                         const SizedBox(height: 4),
                       ],
                       Row(
                         children: [
                           Text(
                             plan.price == "0.00" ? "Free" : "₹${plan.price}",
                             style: TextStyles.headingMobile.copyWith(
                               fontSize: 32,
                               color: isSelected ? Colors.white : Colors.white,
                             ),
                           ),
                           const SizedBox(width: 8),
                            Text(
                              plan.name == "Free" ? "forever" : "/ ${plan.validity_days} days",
                             style: TextStyle(
                               fontSize: 16,
                               color: isSelected ? Colors.white70 : Colors.white60,
                               fontWeight: FontWeight.w500,
                             ),
                           ),
                         ],
                       ),
                     ],
                   ),
                  
                  const SizedBox(height: 24),
                  
                  // Features section
                  Row(
                    children: [
                      Expanded(child: _buildFeatureWidget(plan, "profiles", isSelected)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildFeatureWidget(plan, "ads", isSelected)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildFeatureWidget(plan, "content", isSelected)),
                    ],
                  ),
                    const SizedBox(height: 16),
                    if (isCurrentPlan)
                      Text(
                        "You're enjoying ${plan.name}. You can switch anytime.",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 40,
                        child: isCurrentPlan
                            ? OutlinedButton(
                                onPressed: null,
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.white.withOpacity(0.3)),
                                  foregroundColor: Colors.white70,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text("Current plan"),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  if (plan.name != "Free") {
                                    setState(() {
                                      selectedPlanId = plan.id.toString();
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4F46E5),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                ),
                                child: Text(isSelected ? "Selected" : "Select"),
                              ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureWidget(Daum plan, String feature, bool isSelected) {
    IconData icon;
    String label;
    bool isEnabled;

    switch (feature) {
      case "profiles":
        icon = PhosphorIconsFill.users;
        label = "${plan.maxProfiles} Profiles";
        isEnabled = true;
        break;
      case "ads":
        icon = plan.name == "Free" ? PhosphorIconsFill.x : PhosphorIconsFill.check;
        label = plan.name == "Free" ? "With Ads" : "Ad-Free";
        isEnabled = plan.name != "Free";
        break;
      case "content":
        icon = plan.name == "Free" ? PhosphorIconsFill.cashRegister : PhosphorIconsFill.sketchLogo;
        label = plan.name == "Free" ? "Rental Only" : "Unlimited";
        isEnabled = plan.name != "Free";
        break;
      default:
        icon = PhosphorIconsFill.check;
        label = "Feature";
        isEnabled = true;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.white.withOpacity(0.2)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? Colors.white.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isSelected
                ? Colors.white
                : isEnabled
                    ? Colors.white
                    : Colors.white38,
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected
                  ? Colors.white
                  : isEnabled
                      ? Colors.white
                      : Colors.white38,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getSelectedPlanLabel(List<Daum> plans) {
    final selectedPlan =
        plans.firstWhere((plan) => plan.id.toString() == selectedPlanId);
    return selectedPlan.price == "0.00"
        ? "Continue with Free Plan"
        : "Pay ₹${selectedPlan.price} for ${selectedPlan.name} plan";
  }

  // Calculate original price for strikethrough effect
  String _calculateOriginalPrice(String currentPrice) {
    if (currentPrice == "0.00") return "";
    
    double price = double.tryParse(currentPrice) ?? 0;
    if (price <= 0) return "";
    // Special case: show 149 as original for 99 plan
    if ((price - 99).abs() < 0.01) {
      return "149";
    }
    
    // Smart discount calculation based on price ranges
    double originalPrice;
    if (price <= 15) {
      // For prices up to 15, show 20% discount
      originalPrice = price * 1.25;
    } else if (price <= 50) {
      // For prices 15-50, show 30% discount
      originalPrice = price * 1.43;
    } else if (price <= 100) {
      // For prices 50-100, show 35% discount
      originalPrice = price * 1.54;
    } else {
      // For prices above 100, show 40% discount
      originalPrice = price * 1.67;
    }
    
    return originalPrice.round().toString();
  }

  // Get discount percentage for display
  String _getDiscountPercentage(String currentPrice) {
    if (currentPrice == "0.00") return "";
    
    double price = double.tryParse(currentPrice) ?? 0;
    if (price <= 0) return "";
    // Special case for 99 → 149 display
    if ((price - 99).abs() < 0.01) {
      const original = 149.0;
      final pct = (((original - price) / original) * 100).round();
      return "-$pct%";
    }
    
    // Calculate discount percentage based on price ranges
    int discountPercentage;
    if (price <= 15) {
      discountPercentage = 20;
    } else if (price <= 50) {
      discountPercentage = 30;
    } else if (price <= 100) {
      discountPercentage = 35;
    } else {
      discountPercentage = 40;
    }
    
    return "-$discountPercentage%";
  }
}
